From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Wed, 31 Oct 2012 22:51:09 -0700
Message-ID: <20121101055109.GD19576@blackbox.djwong.org>
References: <20121027013524.GA19591@blackbox.djwong.org>
 <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
 <20121030154844.1898f068@notabene.brown>
 <yq1a9v4884i.fsf@sermon.lab.mkp.net>
 <20121030201424.GD19559@blackbox.djwong.org>
 <20121031091441.5fc6b412@notabene.brown>
 <20121031085604.GC19591@blackbox.djwong.org>
 <20121031115614.GC18424@quack.suse.cz>
 <20121031193652.GF19591@blackbox.djwong.org>
 <5091B075.7030608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40222 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2KAFvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 01:51:25 -0400
Content-Disposition: inline
In-Reply-To: <5091B075.7030608@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2012 at 04:12:53PM -0700, Boaz Harrosh wrote:
> On 10/31/2012 12:36 PM, Darrick J. Wong wrote:
> > On Wed, Oct 31, 2012 at 12:56:14PM +0100, Jan Kara wrote:
> <snip>
> >> You are right that we need a mechanism to push the flags from the devices
> >> through various storage layers up into the bdi filesystem sees to make
> >> things reliable.
> > 
> > md/dm will call blk_integrity_register, so pushing the "stable page writes
> > required" flag through the various layers is already taken care of.  If devices
> > and filesystems can both indicate that they want stable page writes,  I'll have
> > to keep track of however many users there are.
> > 
> 
> Please note again the iscsi case. Say the admin defined half of an md iscsi devices
> with data_integrity and half without.
> 
> For me I would like an OR. If any underline device needs "stable pages" they all
> get them.
> 
> Please also provide - or how easy is to make an API - for the like of iscsi that
> given a request_queue, set the BDI's "stable pages" on. Something like:
> 
> /* stable_pages can only be turned on never off */
> blk_set_stable_pages(struct request_queue); 

I'll have to test this further, but I think at least DM requires that a given
dm device's sub-devices all have the same integrity profile, which atm seems to
imply that stable writes will be turned on for everything or not at all.

Of course, all that goes out the door with iscsi since it doesn't necessarily
care about DIF/DIX but wants stable pages anyway.  It'd be useful to be able to
play around with iscsi too.  Could you point me to where in the iscsi code it
does the copy-and-checksum behavior?

--D

> > It does seem like less work to fix all the filesystems than to dork around with
> > another flag.
> 
> Sure if that is possible, that will be perfect, then I do not need to keep
> the old "unstable pages" code around at all.
> 
> Thanks for working on this
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
