From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: blkid oddities with stale devices in the cache
Date: Sun, 6 Jul 2008 14:40:56 -0400
Message-ID: <20080706184056.GB26084@mit.edu>
References: <485C8AAE.5020005@redhat.com> <48704BB9.1090501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35151 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756975AbYGFSlR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jul 2008 14:41:17 -0400
Content-Disposition: inline
In-Reply-To: <48704BB9.1090501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 05, 2008 at 11:36:09PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > This is w.r.t. https://bugzilla.redhat.com/show_bug.cgi?id=452333
> > 
> > Dave had a few stale entries in blkid.tab; label from a usb key showed
> > up under several non-existent, stale device names.  fstab had LABEL=,
> > mounting by label failed because blkid returned a stale, nonexistent device.
> 
> Ted, ping (when you're done kernel-wrangling anyway)?  Any thoughts on
> this?  Returning cached data for a device when stat says ENOENT seems
> very weird (and wrong).

Check out what I just pushed out to the git repository.  I think this
should solve the problems people have been reporting....

       	     	 	  	      	   - Ted
