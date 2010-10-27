From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 4/6] ext4: move flush_completed_IO to fs/ext4/fsync.c and
 make it static
Date: Wed, 27 Oct 2010 16:43:50 -0400
Message-ID: <AANLkTimd4wrEEweOunnQsGKayf8hZ_u3jHyECJFE4AYR@mail.gmail.com>
References: <1288211391-22331-1-git-send-email-tytso@mit.edu> <1288211391-22331-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41263 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab0J0UoL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Oct 2010 16:44:11 -0400
Received: by iwn10 with SMTP id 10so1324213iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 27 Oct 2010 13:44:11 -0700 (PDT)
In-Reply-To: <1288211391-22331-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 27, 2010 at 4:29 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Fix a namepsace leak by moving the function to the file where it is
> used.

namepsace => namespace

Add "and making it static." I assume.
