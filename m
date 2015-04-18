From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Fsck repair takes very long for 1,761 inodes containing multiply-claimed blocks on ext4
Date: Sat, 18 Apr 2015 09:02:12 -0600
Message-ID: <E6134227-387C-45D9-9978-4147513EF54A@dilger.ca>
References: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com> <20150415190614.GA11592@birch.djwong.org> <20150416150045.GB7445@thunk.org> <CAD-ux61ti+D7_O2Xrtap5WEi7aFryQ4JoX4eO+J7dcuJS=DZag@mail.gmail.com> <20150417210851.GB9700@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Akos Csete <akos.csete@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34142 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbbDRPCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Apr 2015 11:02:14 -0400
Received: by pdbqa5 with SMTP id qa5so158481948pdb.1
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2015 08:02:14 -0700 (PDT)
In-Reply-To: <20150417210851.GB9700@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I had multiple-linked block problems this week as a CF card I was using in
a PVR started failing. The problem was just garbage in the inside table
that happened to have a bit of a pattern and caused many duplicate
blocks. 

One of the patches we have for Lustre, which unfortunately wasn't
installed on this system, is the ability to prefer erasing inodes with
duplicate blocks instead of cloning them. I think the last time I tried to
push this patch it got hung up because I don't understand how to
make the e2fsck.conf and command line defaults interact properly. 

http://git.hpdd.intel.com/tools/e2fsprogs.git/patch/1f9018d5ddf56d5feb9ef156c9684aee6d79cdee

The other patch that would be very useful in this case is "inode badness"
which tries to detect if inodes are garbage and just delete them instead
of turning them into something that appears good in small increments.

http://git.hpdd.intel.com/tools/e2fsprogs.git/patch/8528b0480b132dc9fae37a2e2efe5e9c24c3d56f

Ted didn't like the approach this patch had taken, because he thought
it touched e2fsck in too many places. I was thinking of a different way of
doing this, by hooking into fix_problem() if pctx->ino is set, but
I'm not yet sure if that will work. 

Cheers, Andreas

>> On Apr 17, 2015, at 15:08, Theodore Ts'o <tytso@mit.edu> wrote:
>> 
>> On Fri, Apr 17, 2015 at 04:05:04PM -0400, Akos Csete wrote:
>> 
>> Could I then just wipe the inodes of the older files (and restore them
>> later from backup) and let the new file claim those blocks? Or are the
>> new file's claim to those blocks suspect?
> 
> OK, if the mod times are different, then it probably wasn't a case of
> an inode getting written to the wrong place on disk.  What probably
> did happen is the block allocation bitmaps got corrupted, and so
> blocks that were in use (and should have been marked in use) were not,
> so they got used for some other inode.
> 
> So yes, you can try wiping the inodes for the older files, and hope
> for the best, but it may be that some of the newer files may end up
> getting corrupted.  So you might want to do some spot checks
> afterwards.  And if you have backups, this might be a good time to
> consider going to your backup tapes....
> 
>                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
