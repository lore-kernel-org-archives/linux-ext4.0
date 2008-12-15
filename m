From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Mon, 15 Dec 2008 09:35:55 -0800
Message-ID: <1229362555.19828.2.camel@bobble.smo.corp.google.com>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:58197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYLORf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2008 12:35:59 -0500
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id mBFHZw4V024369
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2008 09:35:58 -0800
In-Reply-To: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-12-10 at 15:54 -0800, Frank Mayhar wrote:
> A few weeks ago I posted a patch for discussion that allowed ext4 to run
> without a journal.  Since that time I've integrated the excellent
> comments from Andreas and fixed several serious bugs.  We're currently
> running with this patch and generating some performance numbers against
> both ext2 (with backported reservations code) and ext4 with and without
> a journal.  It just so happens that running without a journal is
> slightly faster for most everything.

Has anyone had a chance to take a look at this?  Andreas?  Ted?  Anyone?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

