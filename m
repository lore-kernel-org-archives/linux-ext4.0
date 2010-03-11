From: tytso@mit.edu
Subject: Re: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 15:40:20 -0500
Message-ID: <20100311204020.GK1497@thunk.org>
References: <4B991C81.5040506@redhat.com>
 <20100311194032.GI1497@thunk.org>
 <4B994A82.8010204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47343 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0CKUkV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 15:40:21 -0500
Content-Disposition: inline
In-Reply-To: <4B994A82.8010204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 11, 2010 at 01:54:42PM -0600, Eric Sandeen wrote:
> As long as it doesn't contaminate the "core" then sure, but the more twisty
> paths we have, the less likely any of them will be maintainable.  :)
> 
> I just think that before adding more knobs, we need to take a long hard
> look at what it does to the big picture.  When documenting ext4 upstream,
> how many "if ... else if ... else if" clauses do we need?

Fair enough.

I'm all for proposals to get rid of some knobs, too, if we don't think
they serve a purpose.  Recent examples that we've started deprecated
include minixdf --- and I really wonder if we need t have explicit
mount options to enable xattr and acl's.  Anyone object if we just
enable them all the time by default?

              	    	    	    - Ted
