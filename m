From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] ext4: Convert BUG_ON checks to use ext4_error() instead
Date: Tue, 02 Mar 2010 09:03:37 -0800
Message-ID: <1267549417.14467.1.camel@bobble.smo.corp.google.com>
References: <1267535134-16017-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55701 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0CBRDq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Mar 2010 12:03:46 -0500
In-Reply-To: <1267535134-16017-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2010-03-02 at 08:05 -0500, Theodore Ts'o wrote:
> From: fmayhar <fmayhar@google.com>
> 
> Convert a bunch of BUG_ONs to emit a ext4_error() message and return
> EIO.  This is a first pass and most notably does _not_ cover
> mballoc.c, which is a morass of void functions.
> 
> Signed-off-by: fmayhar <fmayhar@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by:  Frank Mayhar <fmayhar@google.com>
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

