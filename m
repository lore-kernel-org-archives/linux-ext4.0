From: David Muchene <david.muchene@avid.com>
Subject: Fsync Performance
Date: Tue, 4 Aug 2015 19:06:13 +0000
Message-ID: <CD10AD6FBDAE574A973D585BD95C239A4769527A@WAL-MBS02.global.avidww.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.108]:25905 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbbHDTN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2015 15:13:57 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,
I'm not sure if this is the place to ask this, if it isn't I apologize.=
 We are occasionally seeing fsync take a very long time (sometimes upwa=
rds of 3s). We decided to run some fio tests and use systemtap to deter=
mine if the disks were the cause of the problem. One of the results fro=
m the tests is that there occasionally there is a significant differenc=
e between time spent doing io, and the total time to complete the fsync=
=2E Is there an explanation to this difference, or is the systemtap scr=
ipt bogus? If it is in fact the driver/disks that is taking a long time=
, does anyone have any suggestions as to how I'd debug that? I apprecia=
te any help you can provide (even if it's pointing me to the relevant d=
ocuments).=20

System Config:
Debian Wheezy,
3.2.6 Kernel,=20
Seagate SSDs=A0 ST200FM0073=20
Mount options=A0=A0 (rw,relatime,user_xattr,barrier=3D1,data=3Dordered)


fio=A0 --time_based --thinktime=3D125000 --rw=3Drandwrite --write_lat_l=
og=3D./throwaway/sm_sd --name=3Dsm_sd --fsync=3D20 --buffered=3D1 --thi=
nktime_blocks=3D20 --rate_iops=3D20 --direct=3D0 --filename=3D/avid/mnt=
/storagemanager0/sm_sd_test --per_job_logs=3D1 --bs=3D4k --output=3D./t=
hrowaway/sm_sd --ioengine=3Dlibaio --runtime=3D36000 --iodepth=3D20 --l=
og_avg_msec=3D1000 --size=3D1024m

fio=A0 --time_based --thinktime=3D16000000 --rw=3Drandwrite --write_lat=
_log=3D./throwaway/sd_sm --name=3Dsd_sm --fsync=3D25 --buffered=3D1 --t=
hinktime_blocks=3D25 --rate_iops=3D25 --direct=3D0 --filename=3D/avid/m=
nt/systemdirector/sm_sd_test --per_job_logs=3D1 --bs=3D128k --output=3D=
=2E/throwaway/sd_sm --ioengine=3Dlibaio --runtime=3D36000 --iodepth=3D2=
0 --log_avg_msec=3D1000 --size=3D1024m


Results
-----------------------------------------------------------------------=
----
Sync Time(uS),=A0=A0 Max IO Time (uS), =A0=A0 Total IO time (us)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 13801,=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =A0=A0=A0 4402, =A0=A0 =A0=A0=A0=A0 =A0=A0=A0 4522
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 13923,=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0 0,=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=
 =A0=A0=A0 0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 348697,=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0=A0=A0 88261, =A0=A0=A0=A0=A0=A0=A0=A0=A0 88375
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 254846,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 170582,=A0=A0=A0=A0=A0=A0 170723
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 318862,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 317069,=A0=A0=A0=A0=A0=A0=A0 317593

///////////////////////////////////////////////////////////////////////=
//////////////////////////////////////////////////////////////////test_=
sync.stp///////////////////////////////////////////////////////////////=
///////////////////////////////////////////////////////////////////////=
//////
global sync_start =3D 0=20
//submission, io-starting, and io completion...
global sync_blocks_start=20
global sync_blocks_end
global PROCNAME =3D "fio"
global sync_beg =3D 0
global sync_end =3D 0
global wrt_beg=A0 =3D 0
global wrt_end=A0 =3D 0
global fm_beg=A0=A0 =3D 0
global fm_end=A0=A0 =3D 0
global thresh =3D 10000
global max_iotime =3D 0
global first_io =3D 0
global last_io =3D 0


function get_next:long(bio:long)%{
=A0=A0=A0 THIS->__retvalue =3D (long)((struct bio*)((long)THIS->bio))->=
bi_next;
=A0=A0=A0=20
%}

function iter_bio(bio){
=A0=A0=A0 bio_itr =3D bio;
=A0=A0=A0 printf("bio list: [");
=A0=A0=A0 while(bio_itr !=3D NULL){
=A0=A0=A0 =A0=A0=A0 printf("%p, ",bio_itr);
=A0=A0=A0 =A0=A0=A0 bio_itr =3D get_next(bio_itr);
=A0=A0=A0 }
=A0=A0=A0 printf("]\n");
}
=A0=A0=A0=20

probe kernel.function("blk_dequeue_request"){
=A0=A0=A0 if(sync_start =3D=3D 1 && execname() =3D=3D PROCNAME){=A0=A0=A0=
=20
=A0=A0=A0 =A0=A0=A0 sync_blocks_start[$rq->bio] =3D gettimeofday_us();
=A0=A0=A0 =A0=A0=A0 if(first_io =3D=3D 0){=20
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 first_io =3D sync_blocks_start[$rq->bio];
=A0=A0=A0 =A0=A0=A0 }
=A0=A0=A0 }
}


probe kernel.function("blk_account_io_completion"){
=A0=A0=A0 if(sync_start =3D=3D 1 && ($req->bio in sync_blocks_start)){
=A0=A0=A0 =A0=A0=A0 sync_blocks_end[$req->bio] =3D gettimeofday_us();=A0=
=A0=A0=20
=A0=A0=A0 =A0=A0=A0 iotime =3D sync_blocks_end[$req->bio] - sync_blocks=
_start[$req->bio];
=A0=A0=A0 =A0=A0=A0 if(iotime > max_iotime){
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 max_iotime =3D iotime;
=A0=A0=A0 =A0=A0=A0 }
=A0=A0=A0 =A0=A0=A0 last_io =3D sync_blocks_end[$req->bio];
=A0=A0=A0 }
}

probe syscall.fsync{
=A0=A0=A0 if(execname() =3D=3D PROCNAME){
=A0=A0=A0 =A0=A0=A0 sync_start =3D 1;
=A0=A0=A0 =A0=A0=A0 sync_beg =3D gettimeofday_us();
=A0=A0=A0 =A0=A0=A0 //printf("sync start: %d\n",gettimeofday_us());
=A0=A0=A0 }
}
=A0
probe syscall.fsync.return{
=A0=A0=A0 if(execname() =3D=3D PROCNAME){
=A0=A0=A0 =A0=A0=A0 sync_start =3D 0;
=A0=A0=A0 =A0=A0=A0 sync_end =3D gettimeofday_us();
=A0=A0=A0 =A0=A0=A0 total_iotime =3D last_io - first_io;
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=20
=A0=A0=A0 =A0=A0=A0 delete sync_blocks_start;
=A0=A0=A0 =A0=A0=A0 delete sync_blocks_end;
=A0=A0=A0=A0=A0=A0=A0 if((sync_end-sync_beg) > thresh){
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 printf("%d,%d,%d %d,%d, %d, %d\n", sync_b=
eg,sync_end,first_io, last_io, sync_end-sync_beg, max_iotime, total_iot=
ime);
=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0 =A0=A0=A0 last_io =3D first_io =3D 0;
=A0=A0=A0 =A0=A0=A0 sync_end =3D 0;
=A0=A0=A0 =A0=A0=A0 max_iotime =3D 0;
=A0=A0=A0 }
}

probe kernel.function("do_writepages") {
=A0=A0=A0 if(execname() =3D=3D PROCNAME){
=A0=A0=A0=A0=A0=A0=A0 wrt_beg =3D gettimeofday_us();
=A0=A0=A0 }
}

probe kernel.function("filemap_write_and_wait_range"){
=A0=A0=A0 if(execname() =3D=3D PROCNAME){
=A0=A0=A0=A0=A0=A0=A0 fm_beg =3D gettimeofday_us();
=A0=A0=A0 }
}

probe kernel.function("filemap_write_and_wait_range").return{
=A0=A0=A0 if(execname() =3D=3D PROCNAME){
=A0=A0=A0=A0=A0=A0=A0 fm_end =3D gettimeofday_us();
=A0=A0=A0 }
}

probe kernel.function("do_writepages").return{
=A0=A0=A0 if(execname() =3D=3D PROCNAME){
=A0=A0=A0=A0=A0=A0=A0 wrt_end =3D gettimeofday_us();
=A0=A0=A0 }
}

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
