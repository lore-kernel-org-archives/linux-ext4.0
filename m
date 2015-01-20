From: Dmitry Monakhov <rjevskiy@gmail.com>
Subject: Re: xfstests tests/ext4/304
Date: Tue, 20 Jan 2015 13:46:26 +0300
Message-ID: <87oaptg265.fsf@openvz.org>
References: <54BDC49F.6040305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	fstests@vger.kernel.org, fio@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <54BDC49F.6040305@cn.fujitsu.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> writes:

> Hi,
>
> Does anyone see xfstests tests/ext4/304 failed in your test environment. =
I run
> this case in v3.19-rc5, it always fails to me... I tried to figure out th=
e true
> reason, below is my analysis, I think either fio tool, or this 304 case h=
as some
> bugs, please have a check. But sorry firstly, I don't have much time to c=
heck fio
> code that deep, I just checked how fio/engines/e4defrag.c is implemented,=
 so you
> can take my analysis as a bug report, thanks in advance :)
>
> When I run tests/ext4/304, this corresponding fio config file is:
> ########################################################
> # Common e4defrag regression tests
> [global]
> ioengine=3Dioe_e4defrag
> iodepth=3D1
> directory=3D/mnt/xfstests/scratch
> filesize=3D3565158400
> size=3D999G
> buffered=3D0
> fadvise_hint=3D0
>
> # Test4
> # Stress test defragmentation engine
> # Several threads perform defragmentation at random position
> # use inplace=3D1 will allocate and free blocks inside defrag event
> # which highly increase defragmentation
> [defrag-fuzzer]
> ioengine=3De4defrag
> iodepth=3D1
> bs=3D8k
> donorname=3Dtest4.def
> filename=3Dtest4
> inplace=3D1
> rw=3Drandwrite
> numjobs=3D4*1
> runtime=3D30*1
> time_based
>
> [aio-dio-verifier]
> ioengine=3Dlibaio
> iodepth=3D128
> iomem_align=3D4k
> numjobs=3D1
> verify=3Dcrc32c-intel
> verify_fatal=3D1
> verify_dump=3D1
> verify_backlog=3D1024
> verify_async=3D1
> verifysort=3D1
> direct=3D1
> bs=3D64k
> rw=3Dwrite
> filename=3Dtest4
> runtime=3D30*1
> time_based
> ########################################################
> You can "fio config-file" directly in an ext4 file system.=20
>
> When I run this case in my v3.19-rc5 virtual machine, I always got a EINV=
AL error.
> This EINVAL error is returned from mext_check_arguments() in fs/ext4/move=
_extent.c:
>
> 	if ((!orig_inode->i_size) || (!donor_inode->i_size)) {
> 		printk(KERN_ERR "ext4 move extent: File size is 0 byte\n");
> 		return -EINVAL;
> 	}
>
> I think there is nothing wrong with ext4 kernel side, so could anyone hel=
p to confirm
> whether e4defrag engine(inplace=3D1 mode) in fio tool or this 304 case is=
 not implemented correctly.
> See my analysis below: I have removed some irrelevant codes.
>
> in fio/engines/e4defrag.c. We check inplace=3D1 mode.
> ###############################################
> static int fio_e4defrag_init(struct thread_data *td)
> {
> 	int r, len =3D 0;
> 	struct e4defrag_options *o =3D td->eo;
> 	struct e4defrag_data *ed;
> 	struct stat stub;
> 	char donor_name[PATH_MAX];
>
> 	....
>
> 	if (!o->inplace) {
> 		long long len =3D td->o.file_size_high - td->o.start_offset;
> 		r =3D fallocate(ed->donor_fd, 0, td->o.start_offset, len);
> 		if (r)
> 			goto err;
> 	}
> 	...
> }
> ...
>
>
> static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
> {
>
> 	int ret;
> 	unsigned long long len;
> 	struct move_extent me;
>=20=09
> 	....
>
> 	if (o->inplace) {
> 		ret =3D fallocate(ed->donor_fd, 0, io_u->offset, io_u->xfer_buflen);  /=
/race point
> 		if (ret)
> 			goto out;
> 	}
>=20=09
> 	...
>
> 	ret =3D ioctl(f->fd, EXT4_IOC_MOVE_EXT, &me);  //race point
> 	len =3D me.moved_len * ed->bsz;
>
> 	...
>
> 	if (o->inplace)
> 		ret =3D ftruncate(ed->donor_fd, 0);  // race point
>
> 	...
> }
> ###############################################
>
> In this case, we fork 4 process to do defragment work. Assume that 3 proc=
ess have fallocated some
> physical blocks, but before they started to do ioctl(EXT4_IOC_MOVE_EXT), =
another process has finished
> its job, and did a ftruncate operation, now donor file's size is 0, then =
the first 3 process will fail
> (because donor file's size is 0, being truncated). I think it's the reaso=
n that tests/ext4/304 fails.
>
> To be honest, I do not know whether there have been some fio internal mec=
hanisms to serialize these operations,
> such as:
> 	/* for inplace=3D1 mode*/
> 	lock();
> 	fallocate(...);
> 	ioctl(EXT4_IOC_MOVE_EXT);
> 	ftruncate(fd, 0);
> 	unlock();
>
> If there are already some mechanisms to protect these races, it'll mean t=
hat there are no much meaning to
> set numjobs greater than 1, because these operation have already been ser=
ialized. If there are no such
> mechanisms,  I think the above scenario will surely be triggered.
>
> I don't know whether I have missed something, but this test 304 really fa=
iled to me.=20
Agree with your findings. This is strange but I never saw this.
In fact this is stress test so it is good thing that it also cower that cod=
e-path.
All we need is to change test to allow EINVAL from concurrent tasks, and
one more single thread which does inplace defrag with dedicated donor
file, such task can not fail. I'll back with the patch.
>
> Regards,
> Xiaoguang Wang
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUvjICAAoJELhyPTmIL6kB2ZkH/2DnkoOT9NwzklBhstZGxO8G
f2itDzShjD+1erldYKQO4jhpeqUFJ7p0WrtHRrkBgndvvP7wiJ45wTFhvO7QeGzU
/Z/zlCYj4dIEbiCHejXi8TesrXkNJLf7tNp2ewS8VWmpk1A21u5VLYLW7l8DNacm
Foqcup4K7+ndw1klI0b9Yl6Qj2nBF1CGlY894YmI7TtajCcscwTGvdZd2CS4GlDJ
BMfnZXnZ5q+WQ79zLeLy2EkPl8xirU3OKwPio636xd0iEgTuKtFvjcrJSmBvarPN
1qxZxMfY1n5ph8geAeyxWhvBgH9DtZf34+Hq/IuBhczhsGto/wTZvGMywnXK2y4=
=NHX/
-----END PGP SIGNATURE-----
--=-=-=--
