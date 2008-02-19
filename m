From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] - detect LVM2 PVs in libblkid
Date: Tue, 19 Feb 2008 09:02:30 -0600
Message-ID: <47BAEF86.8080601@redhat.com>
References: <47A1074F.8090909@redhat.com> <20080219112731.GV25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYBSPCn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 10:02:43 -0500
In-Reply-To: <20080219112731.GV25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> The patch works for me, but it would seem the right thing would be
> print the UUID without the hyphens, i.e.:
> 
>         guOQGdcOE3IafCm0190XkPZTy5fCEanQ
> 
> instead of
> 
> 	guOQGd-cOE3-IafC-m019-0XkP-ZTy5-fCEanQ

But it already does print it without the hyphens.

Or did you mean to say "print the UUID *with* the hyphens?"

-Eric
