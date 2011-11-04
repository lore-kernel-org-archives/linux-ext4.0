From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: quotacheck on 'tune2fs -O quota'
Date: Fri, 4 Nov 2011 10:03:56 +0100
Message-ID: <20111104090356.GC6205@granier.hd.free.fr>
References: <4EB224A9.8030606@whamcloud.com>
 <CAGr1F2FMvsZ6eLJid4z0RpJcAm5paEfbJwrtFE7iqbr_bA4BTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Niu <niu@whamcloud.com>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61973 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1KDJHz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2011 05:07:55 -0400
Received: by wwi36 with SMTP id 36so3156110wwi.1
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2011 02:07:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGr1F2FMvsZ6eLJid4z0RpJcAm5paEfbJwrtFE7iqbr_bA4BTA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2011 at 05:13:21PM -0700, Aditya Kali wrote:
> I have a patch that removes use of existing quota files altogether by
> tune2fs. This is because since we cannot rely on the data in the
> existing quota files (we have to recompute the quota on the system
> anyways), there is no point in reusing those files.

The old quota files also contain enforcement information which will thus be lost.
To sum up, there is no way to upgrade without losing all quota limits?

Cheers,
Johann
