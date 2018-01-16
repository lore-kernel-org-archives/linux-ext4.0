From: Jan Kara <jack@suse.cz>
Subject: Re: e2fsck -D lead to severely damaged filesystem
Date: Tue, 16 Jan 2018 10:03:52 +0100
Message-ID: <20180116090352.lsz4mhpfho3noumx@quack2.suse.cz>
References: <20180115072329.GA20942@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nik@linuxbox.cz
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbeAPJDy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Jan 2018 04:03:54 -0500
Content-Disposition: inline
In-Reply-To: <20180115072329.GA20942@pcnci.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Mon 15-01-18 08:23:29, Nikola Ciprich wrote:
> we were dealing with slow access to directories with lots of
> files (large maildirs), so after some  tests, I came to conclusion
> that optimizing directories using e2fsck -D (on unmounted FS of course)
> helps a lot. So after testing this on our test box, I did it on production
> mailserver mail volume. The I decided to do some tests on newer kernel,
> so I rebooted test box and got lots of fs errors..
> 
> I checked production box, and it got bad as well:
> 
> lots  of dx_probe:829: inode #15949784: block 35579: comm deliver: Directory hole found
> messages.. 
> 
> 
> so I unmounted fs again, run fsck, and got zillion of:
> 
> Inode 18378187 ref count is 2, should be 1.  Fix? yes
> 
> Unattached inode 18378194
> Connect to /lost+found? yes
> 
> messages.. 
> 
> 
> after ~3 hours, I gave up, and recovered FS from backup.. checking fs after
> "repair" showed that some of large mailboxes vanished completely (and appeared in lost+found)
> 
> I think I can rule out hardware problem, since it appeared on two completely different
> systems after some action.. but I'll try to prepare new test environment and reproduce it.
> 
> What I think might be my big mistake is that I was using quite old e2fsprogs - 1.42.6,
> kernel was 4.4.52 (which I know is also a bit old, we're already testig 4.14.x)
> 
> My question is, was that  some known e2fsck problem which got fixed in new version?

Commit 19961cd000 "e2fsck: fix e2fsck -fD directory truncation" sounds like
fixing a similar problem you've observed. So there's reasonable chance
newer e2fsprogs will handle the filesystem fine. But if not, please do
"e2image -r <device> - | xz -c >ext4.image" *before* running e2fsck -D and
put it somewhere for download. That way we can experiment with the metadata
image and see what exactly does e2fsck do wrong. Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
