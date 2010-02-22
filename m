From: Jan Kara <jack@suse.cz>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
	been remounted readonly
Date: Mon, 22 Feb 2010 23:32:52 +0100
Message-ID: <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com> <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com> <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Camille Moncelier <pix@devlife.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36191 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754365Ab0BVWcy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2010 17:32:54 -0500
Content-Disposition: inline
In-Reply-To: <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Feb 18, 2010 at 10:41 PM, Andreas Dilger <adilger@sun.com> wrote:
> 
> > Are you sure this isn't because e2fsck has been run at boot time and changed
> > e.g. the "last checked" timestamp in the superblock?
> >
> No, I replaced /sbin/init by something which compute the sha1sum of
> the root partition, display it then call /sbin/init and I can see that
> the hash has changed after mount -o remount,ro.
> 
> As little as I understand, I managed to make a diff between two
> hexdump of small images where changes happened after I created a file
> and remounted the fs ro and it seems that, the driver didn't wrote
> changes to the disk until unmount  ( The hexdump clearly shows that
> /lost+found and /test file has been written after the umount )
> 
> workaround: Is there some knob in /proc or /sys which can trigger all
> pending changes to disk ? ( Like /proc/sys/vm/drop_caches but for
> filesystems ? )
  I've looked at your script. The problem is that "echo s >/proc/sysrq_trigger"
isn't really a data integrity operation. In particular it does not wait on
IO to finish (with the new writeback code it does not even wait for IO to be
submitted) so you sometimes take the image checksum before the sync actually
happens. If you used sync(1) instead, everything should work as expected...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
