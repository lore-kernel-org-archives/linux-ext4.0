From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 30 Oct 2008 21:20:21 -0700
Message-ID: <1225426821.20901.2.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
	 <20081030234037.GU3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>,
	Peter Kukol <pkukol@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:24424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYJaEU0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 00:20:26 -0400
In-Reply-To: <20081030234037.GU3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-10-30 at 17:40 -0600, Andreas Dilger wrote:
> Firstly,
> thanks for working on this.  It is a huge patch, and my suggested
> changes are some effort to reduce the size of the patch and keep
> this functionality more maintainable.

Andreas, thanks very much for your comments.  They all seem to make
sense; I'll go through them in detail over the next couple of days and
generate a new patch.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

