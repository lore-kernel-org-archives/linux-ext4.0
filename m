From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Date: Tue, 25 Sep 2007 07:49:38 -0500
Message-ID: <20070925074938.2321bc15@gara>
References: <1190713240.3154.20.camel@castor.rsk.org>
	<20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
	<46F8EB26.2090104@linux.vnet.ibm.com>
	<20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	richard kennedy <richard@rsk.demon.co.uk>, sct@redhat.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:56577 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXIYMti (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 08:49:38 -0400
In-Reply-To: <20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Sep 2007 13:50:46 +0200
Jan Kara <jack@ucw.cz> wrote:
> > Jan Kara wrote:
> > >>
> > >-#define create_jbd_proc_entry() do {} while (0)
> > >-#define remove_jbd_proc_entry() do {} while (0)
> > >+static ctl_table fs_table[] = {
> > >+	{
> > >+                .ctl_name       = -1,	/* Don't want it */
> > 
> > 
> > 
> > shouldn't this be CTL_UNNUMBERED ?
>   Oh, it should be. I didn't notice we have this :) Thanks for notifying
> me. Attached is a fixed version.

This was fixed in JBD2 by moving the jbd-debug file to debugfs:
http://lkml.org/lkml/2007/7/11/334

Since this code is already in the kernel, we should keep it consistent. 

-JRS
