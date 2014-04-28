From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/7] mke2fs: don't ask the proceed question using a regular
 file
Date: Mon, 28 Apr 2014 10:24:32 -0500
Message-ID: <535E72B0.6030002@redhat.com>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbaD1PYh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 11:24:37 -0400
In-Reply-To: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/26/14, 7:00 PM, Theodore Ts'o wrote:
> Very often people are creating file systems using regular files, so we
> shouldn't ask the user to confirm using the proceed question.
> Otherwise it encourages users to use the -F flag, which is a bad
> thing.

Yup, agreed - that'll be nice.

Acked-by: Eric Sandeen <sandeen@redhat.com>


