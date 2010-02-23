From: Jan Kara <jack@suse.cz>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
	been remounted readonly
Date: Tue, 23 Feb 2010 14:55:31 +0100
Message-ID: <20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com> <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com> <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com> <20100222223252.GA13882@atrey.karlin.mff.cuni.cz> <20100222230552.GB13882@atrey.karlin.mff.cuni.cz> <16F918FB-F45D-478E-9358-550BB39E277E@sun.com> <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: Camille Moncelier <pix@devlife.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The fact is that I've been able to reproduce the problem on LVM block
> devices, and sd* block devices so it's definitely not a loop device
> specific problem.
> 
> By the way, I tried several other things other than "echo s
> >/proc/sysrq_trigger" I tried multiple sync followed with a one minute
> "sleep",
> 
> "echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
> changes" but doesn't stops them.
  Strange. When I use sync(1) in your script and use /dev/sda5 instead of a
/dev/loop0, I cannot reproduce the problem (was running the script for
something like an hour).
  So can you send me (or put up somewhere) the different images of filesystems
you've got when you run on /dev/sd* with using sync in your script?

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
