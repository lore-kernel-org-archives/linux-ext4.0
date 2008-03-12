From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC, PATCH 5/6] jbd: add support for read-only log recovery
Date: Wed, 12 Mar 2008 11:51:21 +0100
Message-ID: <20080312105121.GB3090@duck.suse.cz>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <7f095bf2403465433796f2f7aab20f1c9a2e0f73.1204685366.git.duaneg@dghda.com> <20080311150514.GC6544@atrey.karlin.mff.cuni.cz> <20080312014056.GA21711@dastardly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47512 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751486AbYCLKvW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2008 06:51:22 -0400
Content-Disposition: inline
In-Reply-To: <20080312014056.GA21711@dastardly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 12-03-08 01:40:56, Duane Griffin wrote:
> > > +		}
> > > +		if (err) {
> > >  			printk(KERN_ERR "JBD: Out of memory during recovery\n");
> > >  			success = err;
> > >  			goto failed;
> > >  		}
> > >  
> > ->  		++info->nr_replays;
> 
> Sorry, not sure if you are pointing something out or if this is a mailer
> glitch. If the former, I'm afraid I don't understand.
  Just a glitch, ignore that.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
