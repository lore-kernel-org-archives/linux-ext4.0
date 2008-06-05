From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
 buffers
Date: Thu, 5 Jun 2008 09:20:06 -0700
Message-ID: <20080605092006.ba7dceef.akpm@linux-foundation.org>
References: <4843CE15.6080506@hitachi.com>
	<4843CEED.9080002@hitachi.com>
	<20080603153050.fb99ac8a.akpm@linux-foundation.org>
	<20080604101925.GB16572@duck.suse.cz>
	<20080604111911.c1fe09c6.akpm@linux-foundation.org>
	<20080604212202.GA8727@mit.edu>
	<20080604145848.e3da6f20.akpm@linux-foundation.org>
	<20080604225155.GB8727@mit.edu>
	<20080605093536.GE27370@duck.suse.cz>
	<4847CF07.1020904@hitachi.com>
	<20080605142948.GA25477@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Jan Kara <jack@suse.cz>, sct@redhat.com, adilger@sun.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760954AbYFEQVX@vger.kernel.org>
In-Reply-To: <20080605142948.GA25477@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 5 Jun 2008 10:29:48 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Jun 05, 2008 at 08:33:27PM +0900, Hidehiro Kawai wrote:
> > 
> > My patch doesn't change the policy.  JBD aborts the journal when
> > it detects I/O error in file data since 2.6.11.  Perhaps this patch:
> > http://marc.info/?l=linux-kernel&m=110483888632225
> > I just added missing error checkings.
> > 
> 
> Looking at the code paths touched by patch you referenced, you are
> correct.  And Andrew even signed off on it.  :-)
> 
> But if someone was only examining the patch, it wasn't obvious that
> the journal was getting aborted when the JBD layer was forcing buffers
> from t_sync_datalist to disk.  So I suspect the change went in without
> proper consideration of the net effect.  You just called it out
> explicitly in the subject line, which caused Andrew to ask some good
> questions; questions that weren't asked in 2005.

Sigh. An object lesson in the value of good changelogging :(

I guess we need to undo this.  And yes, propagating errors into AS_EIO
is the way.  I guess that's safe without holding lock_page(), as long
as the bh is pinned.
