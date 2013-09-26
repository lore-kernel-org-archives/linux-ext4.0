From: InvTraySts <invtrasys@gmail.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 21:41:55 -0400
Message-ID: <CAOWv6b15AJQ=v2A8sTG8Z2BMbpcFvPNOgZXrin4PLTnHT8ypJQ@mail.gmail.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com>
 <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com>
 <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com>
 <20130925161259.GA5404@quack.suse.cz> <CAOWv6b3xh34_86QWy7O24U-voQ2JXw5JFDThgoiXD27WOMCZxQ@mail.gmail.com>
 <20130925212834.GA10542@quack.suse.cz> <CAOWv6b3OPaSMRvE8cG5_6Qkq-gUGheX7hccmLtO=z7wkekq8ZA@mail.gmail.com>
 <52438706.3090706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60485 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3IZBmh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Sep 2013 21:42:37 -0400
Received: by mail-wg0-f42.google.com with SMTP id m15so5608434wgh.1
        for <linux-ext4@vger.kernel.org>; Wed, 25 Sep 2013 18:42:36 -0700 (PDT)
In-Reply-To: <52438706.3090706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After running e2fsck on the copied drive,
e2fsck -y /dev/sdf1
[long output]
Illegal double indirect block (1162627398) in inode 792606.  CLEARED.
Inode 792606 is too big.  Truncate? yes

Block #2206781 (1047) causes directory to be too big.  CLEARED.
Error storing directory block information (inode=792606, block=0,
num=818574): Memory allocation failed

root: ***** FILE SYSTEM WAS MODIFIED *****
e2fsck: aborted

root: ***** FILE SYSTEM WAS MODIFIED *****
root@server:~#

mount reports an error:
[793486.478664] EXT4-fs error (device sdf1):
htree_dirblock_to_tree:892: inode #2: block 20037: comm ls: bad entry
in directory: inode out of bounds - offset=0(0), inode=1162627398,
rec_len=48, name_len=3
[799147.110694] EXT4-fs (sdf1): ext4_check_descriptors: Checksum for
group 0 failed (32817!=0)
[799147.110698] EXT4-fs (sdf1): group descriptors corrupted!

On Wed, Sep 25, 2013 at 8:59 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 9/25/13 7:08 PM, InvTraySts wrote:
>> (Going to merge these two back, because both of you are actually
>> helping me, but with the two conversations being segregated like this
>> it makes it hard to correlate with you both)
>> The partprobe did work with getting the partition table reread.
>> After that, the tune2fs sorta worked.
>> root@server:~# tune2fs -f -O ^has_journal /dev/sdf1
>> tune2fs 1.42.5 (29-Jul-2012)
>> root@server:~# mount /dev/sdf1 /media/tmp
>> root@server:~# ls -l /media/tmp/
>> total 0
>>
>> When I try and use the debugfs /dev/sdf1
>>
>> root@server:~# debugfs /dev/sdf1
>> debugfs 1.42.5 (29-Jul-2012)
>> debugfs:  ls
>> EXT2 directory corrupted
>> debugfs:  ls /
>> /: EXT2 directory corrupted
>
> At this point you could try e2fsck on the _copy_, to see what it
> can do.
>
> Seems like something quite bad may have happened to your storage,
> though, and e2fsck may not be magical for you.
>
> -Eric
>
