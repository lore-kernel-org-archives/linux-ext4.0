From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH, RFC] jbd2: Call the commit callback before the
 transaction could get dropped
Date: Tue, 28 Oct 2008 09:46:05 -0400
Message-ID: <1225201565.7743.2.camel@localhost.localdomain>
References: <1224612181.19719.20.camel@paris-laptop>
	 <20081027181928.GB23111@mit.edu> <49064027.9010509@redhat.com>
	 <20081027232843.GA9797@mit.edu> <49065805.1080303@redhat.com>
	 <20081028015228.GA8320@mit.edu> <20081028022838.GA8869@mit.edu>
	 <49067BE0.8090904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbYJ1O3u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2008 10:29:50 -0400
In-Reply-To: <49067BE0.8090904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-10-27 at 21:41 -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > This is what I plan to send to Linus to fix the problem.
> > 
> > commit 6fecbc3c7d27800e90a5f5fbca2fb2847e2c2854
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Mon Oct 27 22:11:39 2008 -0400
> > 
> >     jbd2: Call the commit callback before the transaction could get dropped
> >     
> >     The transaction can potentially get dropped if there are no buffers
> >     that need to be written.  Make sure we call the commit callback before
> >     potentially deciding to drop the transaction.  Also avoid
> >     dereferencing the commit_transaction pointer in the marker for the
> >     same reason.
> >     
> >     This patch fixes the bug reported by Eric Paris at:
> >     http://bugzilla.kernel.org/show_bug.cgi?id=11838
> >     
> >     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>

Tested-by: Eric Paris <eparis@redhat.com>

