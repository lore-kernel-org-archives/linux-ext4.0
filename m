From: "Bradley C. Kuszmaul" <kuszmaul@gmail.com>
Subject: Re: hole punching in ext4
Date: Tue, 22 Jan 2013 18:50:00 -0500
Message-ID: <CAKSyJXew+Sx0AB8HgDZxtOvXyKt8Z_UOe4eG1C=27m2_ubdMVw@mail.gmail.com>
References: <CAKSyJXfvTFjGMO2ZZPsnSjc_fnUzfs2oMrYf7UQoPvO0=98FxA@mail.gmail.com>
 <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com> <20130122162009.GB2072@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:45361 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AVXuW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 18:50:22 -0500
Received: by mail-ie0-f181.google.com with SMTP id 16so12607834iea.26
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 15:50:22 -0800 (PST)
In-Reply-To: <20130122162009.GB2072@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, this has been a very helpful thread.

How do I determine and control whether a file is extent-based?

-Bradley


On Tue, Jan 22, 2013 at 11:20 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Ext4 file system supports hole punching.  But until now only extent-based
> file supports it.  As far as I know, redhat distributions don't support
> hole punching.  You can find a sample program from e2fsprogs which is in
> $e2fsprogs/conrib/fallocate.c.  The latest fallocate(1) in util-linux
> also can be as a demo.
