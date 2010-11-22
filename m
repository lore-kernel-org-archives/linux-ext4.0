From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
Date: Mon, 22 Nov 2010 09:34:40 -0800
Message-ID: <AANLkTimDZ26GPdTQaqF98=67qhOpRLuy+8Wpt=eXcV82@mail.gmail.com>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
	<60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
	<093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Namhyung Kim <namhyung@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59336 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0KVRel (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Nov 2010 12:34:41 -0500
In-Reply-To: <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 5:05 AM, Theodore Tso <tytso@mit.edu> wrote:
> Oooh, I forgot another downside which just came to mind:
>
> * Call of this code churn to fix whitespace all for the sake of keep some damned checkpatch.pl script happy also breaks "git blame" reports.
>
> -- Ted

Isn't that what git blame -w  (ignore whitespace) is for?

Harvey
