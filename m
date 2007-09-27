From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Date: Thu, 27 Sep 2007 00:23:11 -0500
Message-ID: <20070927002311.46e50dfb@gara>
References: <1190713240.3154.20.camel@castor.rsk.org>
	<20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
	<46F8EB26.2090104@linux.vnet.ibm.com>
	<20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
	<20070925074938.2321bc15@gara>
	<20070925084153.36ab65a5@gara>
	<20070925143608.GB18758@atrey.karlin.mff.cuni.cz>
	<20070926143539.b01bc0bc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, aneesh.kumar@linux.vnet.ibm.com,
	richard@rsk.demon.co.uk, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49262 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbXI0FXE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 01:23:04 -0400
In-Reply-To: <20070926143539.b01bc0bc.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 26 Sep 2007 14:35:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 25 Sep 2007 16:36:08 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > > On Tue, 25 Sep 2007 07:49:38 -0500
> > > "Jose R. Santos" <jrs@us.ibm.com> wrote:
> > > 
> > > > On Tue, 25 Sep 2007 13:50:46 +0200
> > > > Jan Kara <jack@ucw.cz> wrote:
> > > > > > Jan Kara wrote:
> > > > > > >>
> > > > > > >-#define create_jbd_proc_entry() do {} while (0)
> > > > > > >-#define remove_jbd_proc_entry() do {} while (0)
> > > > > > >+static ctl_table fs_table[] = {
> > > > > > >+	{
> > > > > > >+                .ctl_name       = -1,	/* Don't want it */
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > shouldn't this be CTL_UNNUMBERED ?
> > > > >   Oh, it should be. I didn't notice we have this :) Thanks for notifying
> > > > > me. Attached is a fixed version.
> > > > 
> > > > This was fixed in JBD2 by moving the jbd-debug file to debugfs:
> > > > http://lkml.org/lkml/2007/7/11/334
> > > > 
> > > > Since this code is already in the kernel, we should keep it consistent. 
> > > > 
> > > 
> > > OK.  Here's a quick patch to fix this.  Adapted from the JBD2 patch.
> > > Let me know what you think.
> >   Looks fine - exactly what I've just done here :).
> 
> hm.  I found rather a lot of issues.  If this patch is derived from the
> JBD2 patch then perhaps the JBD2 patch needs some looking at.

Some of the changes do apply to the JBD2 patch.  I'll send a cleanup patch.

> 
> > >     Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> >   You can add Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I suspect you might be getting your signed-off-bys and acked-bys mixed up. 
> (If not this patch, then the previous one).  Please see
> Documentation/SubmittingPatches section 13 for the difference.
> 
> Jose, please review and if possible runtime test these proposed changes?

Agree with all the changes and they worked as expected on my system. 

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> - use `#ifdef foo' instead of `#if defined(foo)'
> 
> - CONFIG_JBD_DEBUG depends on CONFIG_DEBUG_FS so we don't need to duplicate
>   that logic in the .c file ifdefs
> 
> - Make journal_enable_debug __read_mostly just for the heck of it
> 
> - Make jbd_debugfs_dir and jbd_debug static
> 
> - debugfs_remove(NULL) is legal: remove unneeded tests
> 
> - jbd_create_debugfs_entry is a better name than create_jbd_debugfs_entry
> 
> - ditto remove_jbd_debugfs_entry
> 
> - C functions are preferred over macros
> 
> Cc: "Jose R. Santos" <jrs@us.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jose R. Santos <jrs@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Jose R. Santos <jrs@us.ibm.com>

-JRS
