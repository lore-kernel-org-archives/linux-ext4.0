From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Tue, 21 Apr 2009 11:40:08 -0500
Message-ID: <49EDF6E8.7070101@redhat.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com>	<gshfgl$o6m$1@ger.gmane.org> <m2eivm599b.fsf@vador.mandriva.com>	<49EDEBCC.3030008@redhat.com> <m23ac255pp.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeremy Sanders <jss@ast.cam.ac.uk>, linux-ext4@vger.kernel.org
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120AbZDUQkg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2009 12:40:36 -0400
In-Reply-To: <m23ac255pp.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thierry Vignaud wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
>>>> However, the system seems to mostly work, so I recreated the ext4 device, 
>>>> I've just run my backup script again and fsck'd the device. It seems the 
>>>> problem is reproducible with the new kernel:
>>>>
>>>> [root@xback2 ~]# fsck /dev/md0
>>>> fsck 1.41.4 (27-Jan-2009)
>>>> e2fsck 1.41.4 (27-Jan-2009)
>>>> fsck.ext4: Group descriptors look bad... trying backup blocks...
>>>> Group descriptor 0 checksum is invalid.  Fix<y>?
>>>>
>>>> Looks like there's a real problem in ext4 causing this under certain 
>>>> circumstances (unless an obscure hardware error is somehow giving the same 
>>>> problem).
>>>>
>>>> To cause this, all I did was rsync a set of directories to the disk. No hard 
>>>> link trees were created.
>>> For the record, I reproduced this bug with 2.6.30-rc2-git6 on a new
>>> 1.5Tb disk. Formated as ext4, using relatime, copied 20Gb.
>>> On reboot, I got such errors.
>>> The hd was partitionned (all ext4) as:
>>> / (5Gb)  |  /usr (20Gb)  |  /pub (1.5Tb)
>>>
>>> The smaller system fses didn't saw those errors.
>> Can you provide a little more info on how you copied the 20Gb, and
>> exactly what the errors were?
> 
> I just copied some files from an USB hard disc with cp on the big
> partition (the one that showed the issues).
> For other system partitions (that showed _no_ problems) were filled with
> something like "rsync -rvltpx / /where/it/was/mounted"
> 
> Here's the fsck log:
> 
> 
>-----------------------------------------------------------------------

Wow, awful.

Could you send me dumpe2fs -h output of the large target device, as well
as an "e2image -r" image of the source filesystem?  That way I can
hopefully perfectly replicate your target filesystem as well as the data
you're using to populate it, try the cp myself, and see if I hit the
same thing.

e2image only sends metadata information, not data.  If you are concerned
about filenames, use -s to scramble them, though this *might* impact my
ability to reproduce it...

Thanks,
-Eric
