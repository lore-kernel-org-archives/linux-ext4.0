From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Wed, 2 Sep 2009 18:09:39 -0400
Message-ID: <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:64983 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZIBWJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 18:09:43 -0400
Received: by qw-out-2122.google.com with SMTP id 8so441469qwh.37
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 15:09:45 -0700 (PDT)
In-Reply-To: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrote:
> If we allocate the donor file once for all, it will have a better chance
> to be continuous.
>
> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>

Seems like an improvement, but I'm not seeing any special handling for
sparse files.  (Not before or after this patch.)

Seems like there should be an outer loop that identifies contiguous
data block sets in a sparse file and defrags them individually as
opposed to trying to defrag the entire file at once.

My impression is that with a large sparse file, e4defrag currently
(with or without this patch) would fallocate a full non-sparse donor
set of blocks the full size of the original file, then swap in just
the truly allocated blocks?

If so, that is not very optimum.

Greg
