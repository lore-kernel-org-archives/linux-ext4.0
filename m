From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: [PATCH] Documentation/filesystems/ext3.txt
Date: Tue, 19 May 2009 18:49:48 +0100
Message-ID: <20090519184948.0d94f779@digital-domain.net>
References: <20090518212209.17c46cee@digital-domain.net>
	<4A12C3A4.90202@redhat.com>
	<20090519170358.5d38a2bc@zeus.int.pccl>
	<4A12DB4D.4080407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.painless.aaisp.net.uk ([81.187.30.52]:53563 "EHLO
	b.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZESRtv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 13:49:51 -0400
In-Reply-To: <4A12DB4D.4080407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 19 May 2009 11:16:13 -0500, Eric Sandeen wrote:

> Andrew Clayton wrote:
> > --- ext3.txt.orig	2009-05-19 16:31:17.000000000 +0100
> > +++ ext3.txt	2009-05-19 16:59:35.000000000 +0100
> > @@ -39,11 +39,11 @@
> >  data=journal		All data are committed into the
> > journal prior to being written into the main file system.
> >  
> > -data=ordered	(*)	All data are forced directly out to
> > the main file +data=ordered		All data are forced
> > directly out to the main file system prior to its metadata being
> > committed to the journal.
> >  
> > -data=writeback		Data ordering is not preserved, data
> > may be written +data=writeback	(*)	Data ordering is
> > not preserved, data may be written into the main file system after
> > its metadata has been committed to the journal.
> 
> I guess I'd still rather see a "see below" or something here, because
> I think this is a critical change.  Perhaps you can tell I have a
> slight agenda ;)  I think writeback as default is a terrible choice,

Heh, yeah.

> and at least full disclosure of risks is in order....
>
> > @@ -160,16 +160,19 @@
> >  There are 3 different data modes:
> >  
> >  * writeback mode
> > -In data=writeback mode, ext3 does not journal data at all.  This
> > mode provides -a similar level of journaling as that of XFS, JFS,
> > and ReiserFS in its default -mode - metadata journaling.  A
> > crash+recovery can cause incorrect data to -appear in files which
> > were written shortly before the crash.  This mode will -typically
> > provide the best ext3 performance. +If no mode is explicitly set
> > then this is the default mode.  In data=writeback +mode, ext3 does
> > not journal data at all.  This mode provides a similar level of
> > +journaling as that of XFS, JFS, and ReiserFS in its default mode -
> > metadata +journaling.  A crash+recovery can cause file corruption
> > and may lead to +sensitve data to appear in files which were
> > written shortly before the crash. +This mode will typically provide
> > the best ext3 performance.
> 
> I'd do something like:
> 
> ---
> If no mode is explicitly set then this is the default mode.  In
> data=writeback mode, ext3 does not journal data at all.  This mode
> provides a similar level of journaling as that of XFS, JFS, and
> ReiserFS in its default mode - metadata journaling.  Unlike these
> other filesystems, however, a crash+recovery of ext3 in writeback
> mode can cause file data corruption by allowing stale or sensitive
> data to appear in files which were written shortly before the crash.
> This mode will typically provide the best ext3 performance.
> ---
> 
> I propose this change because the implication that this mode is no
> worse than what other journaling filesystems do is wrong, IMHO.  Other
> filesystems consider this sort of stale data exposure to be a bug and
> a security flaw.  :)

Sure.
 
> Thanks,
> -Eric

OK, I've made the suggested changes.

Cheers,

Andrew


Update the ext3 document with the fact that data=writeback is now
the default journaling mode and emphasise the implications of this as
pointed out by Eric Sandeen.. Also mention that the default can be 
turned back to ordered mode via CONFIG_EXT3_DEFAULTS_TO_ORDERED

Signed-off-by: Andrew Clayton <andrew@digital-domain.net>

--- ext3.txt.orig	2009-05-19 18:31:22.885057195 +0100
+++ ext3.txt	2009-05-19 18:39:52.173063273 +0100
@@ -39,13 +39,15 @@
 data=journal		All data are committed into the journal prior to being
 			written into the main file system.
 
-data=ordered	(*)	All data are forced directly out to the main file
+data=ordered		All data are forced directly out to the main file
 			system prior to its metadata being committed to the
 			journal.
 
-data=writeback		Data ordering is not preserved, data may be written
+data=writeback	(*)	Data ordering is not preserved, data may be written
 			into the main file system after its metadata has been
-			committed to the journal.
+			committed to the journal. NOTE: See the writeback text 
+			in the "Data Mode" section below for the implications 
+			of this.
 
 commit=nrsec	(*)	Ext3 can be told to sync all its data and metadata
 			every 'nrsec' seconds. The default value is 5 seconds.
@@ -160,16 +162,20 @@
 There are 3 different data modes:
 
 * writeback mode
-In data=writeback mode, ext3 does not journal data at all.  This mode provides
-a similar level of journaling as that of XFS, JFS, and ReiserFS in its default
-mode - metadata journaling.  A crash+recovery can cause incorrect data to
-appear in files which were written shortly before the crash.  This mode will
-typically provide the best ext3 performance.
+If no mode is explicitly set then this is the default mode.  In data=writeback 
+mode, ext3 does not journal data at all.  This mode provides a similar level of
+journaling as that of XFS, JFS, and ReiserFS in its default mode - metadata 
+journaling.  Unlike these other filesystems however, a crash+recovery of ext3 
+can cause file corruption by allowing stale or sensitve data to appear in files
+which were written shortly before the crash.  This mode will typically provide 
+the best ext3 performance.
 
 * ordered mode
-In data=ordered mode, ext3 only officially journals metadata, but it logically
-groups metadata and data blocks into a single unit called a transaction.  When
-it's time to write the new metadata out to disk, the associated data blocks
+This mode can be made the default via the kernel config option
+CONFIG_EXT3_DEFAULTS_TO_ORDERED.  In data=ordered mode, ext3 only officially 
+journals metadata, but it logically groups metadata and data blocks into a 
+single unit called a transaction.  
+When it's time to write the new metadata out to disk, the associated data blocks
 are written first.  In general, this mode performs slightly slower than
 writeback but significantly faster than journal mode.
 
