From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Tue, 21 Apr 2009 10:52:44 -0500
Message-ID: <49EDEBCC.3030008@redhat.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com>	<gshfgl$o6m$1@ger.gmane.org> <m2eivm599b.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeremy Sanders <jss@ast.cam.ac.uk>, linux-ext4@vger.kernel.org
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43871 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZDUPxO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2009 11:53:14 -0400
In-Reply-To: <m2eivm599b.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thierry Vignaud wrote:
> Jeremy Sanders <jss@ast.cam.ac.uk> writes:
> 
>> However, the system seems to mostly work, so I recreated the ext4 device, 
>> I've just run my backup script again and fsck'd the device. It seems the 
>> problem is reproducible with the new kernel:
>>
>> [root@xback2 ~]# fsck /dev/md0
>> fsck 1.41.4 (27-Jan-2009)
>> e2fsck 1.41.4 (27-Jan-2009)
>> fsck.ext4: Group descriptors look bad... trying backup blocks...
>> Group descriptor 0 checksum is invalid.  Fix<y>?
>>
>> Looks like there's a real problem in ext4 causing this under certain 
>> circumstances (unless an obscure hardware error is somehow giving the same 
>> problem).
>>
>> To cause this, all I did was rsync a set of directories to the disk. No hard 
>> link trees were created.
> 
> For the record, I reproduced this bug with 2.6.30-rc2-git6 on a new
> 1.5Tb disk. Formated as ext4, using relatime, copied 20Gb.
> On reboot, I got such errors.
> The hd was partitionned (all ext4) as:
> / (5Gb)  |  /usr (20Gb)  |  /pub (1.5Tb)
> 
> The smaller system fses didn't saw those errors.

Can you provide a little more info on how you copied the 20Gb, and
exactly what the errors were?

Thanks,
-Eric
