From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 27/28] ext4: Convert BUG_ON checks to use ext4_error()
	instead
Date: Mon, 08 Mar 2010 09:46:11 -0800
Message-ID: <1268070371.5347.8.camel@bobble.smo.corp.google.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
	 <1267553925-6308-28-git-send-email-tytso@mit.edu>
	 <87r5nxsitn.fsf@linux.vnet.ibm.com>  <20100307024531.GB5395@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:7582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0CHRqQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 12:46:16 -0500
In-Reply-To: <20100307024531.GB5395@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2010-03-06 at 21:45 -0500, tytso@mit.edu wrote:
> On Sat, Mar 06, 2010 at 06:33:48PM +0530, Aneesh Kumar K. V wrote:
> > 
> > I guess ext4_error and ext4_warning are now not taking __func__. So we
> > to be consistant with thos i this this can be in lower case even though
> > they are #defines.
> 
> Or maybe we should rename them be EXT4_ERROR and EXT4_WARNING.  What
> do other people think?

I guess I'm joining the apathetic majority when I say that it doesn't
matter to me at all.  Keeping them as-is is fine.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

