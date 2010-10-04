From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v4] Lazy itable initialization for Ext4
Date: Mon, 4 Oct 2010 15:19:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010041516550.2865@dhcp-lab-213.englab.brq.redhat.com>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com> <20100928040142.GA7865@thunk.org> <alpine.LFD.2.00.1009291516270.2982@dhcp-lab-213.englab.brq.redhat.com> <alpine.LFD.2.00.1010011752280.2854@dhcp-lab-213.englab.brq.redhat.com>
 <20101002195535.GM21129@thunk.org> <20101003024329.GO21129@thunk.org> <20101004023649.GA2889@thunk.org> <alpine.LFD.2.00.1010041427390.2865@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, adilger@dilger.ca,
	snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab0JDNTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Oct 2010 09:19:51 -0400
In-Reply-To: <alpine.LFD.2.00.1010041427390.2865@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 4 Oct 2010, Lukas Czerner wrote:

> Hi Ted,
> 
> first of all, thank you very much for tracking down those issues and for
> all the improvement you have done on this. Now, I have some questions
> about changes you have introduced with this patch.
> 
> On Sun, 3 Oct 2010, Ted Ts'o wrote:
> 
> > I've made some more changes.  This version updates the timing control.
> > The major changes are:
> > 
> > 1) Time the it takes to clear the inode table with a barrier (once),
> > and then use it for the rest of the block groups for that file system.
> 
> So if I understand this right it means that we measure the time it takes
> to zeroout inode table just once (set the lr_timeout) and then we use
> this value for all the following zeroouts.
> 
> Initially I have done this "measuring time" thing to adaptively balance
> the load it generates and thus do not disturb other ongoing I/O very
> much. So this change does not really make sense to me, because when we
> measure the time right after the mount (just once) and the system is
> relatively still we end up with rather small lr_timeout and then, when
> system is under heavy load it will keep the same zeroout rate as when
> system was still - resulting in much more impact on performance than my
> previous solution.
> 
> Conversely, when the system is under heavy load when the filesystem
> with init_itable option is mounted the zeroing will proceed very slowly
> even if the system is relatively still later on.
> 
> > 
> > 2) s_li_wait_nult wasn't getting defaulted, so we weren't waiting any
> > time at all between sb_issue_zeroout calls.
> 
> Actually it is getting defaulted:
> 
> +		case Opt_init_inode_table:
> +			set_opt(sbi->s_mount_opt, INIT_INODE_TABLE);
> +			if (args[0].from) {
> +				if (match_int(&args[0], &option))
> +					return 0;
> +			} else
> +				option = EXT4_DEF_LI_WAIT_MULT;
> +			if (option < 0)
> +				return 0;
> +			sbi->s_li_wait_mult = option;
> +			break;

Ok, this is not right:) and it is probably why do you thought that it was
not getting defaulted at all (because it actually did not). It should be:

		case Opt_init_inode_table:
			set_opt(sbi->s_mount_opt, INIT_INODE_TABLE);
			option = EXT4_DEF_LI_WAIT_MULT;
			if (args[0].from) {
				if (match_int(&args[0], &option))
					return 0;
			if (option < 0)
				return 0;
			sbi->s_li_wait_mult = option;
			break;

> 
> EXT4_DEF_LI_WAIT_MULT is the default value for s_li_wait_mult.
> 

-Lukas
