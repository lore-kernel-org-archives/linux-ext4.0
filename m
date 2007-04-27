From: "Marat Buharov" <marat.buharov@gmail.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 15:59:56 +0400
Message-ID: <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Mike Galbraith" <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Jens Axboe" <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:55350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbXD0L76 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 07:59:58 -0400
Received: by ug-out-1314.google.com with SMTP id 44so802566uga
        for <linux-ext4@vger.kernel.org>; Fri, 27 Apr 2007 04:59:57 -0700 (PDT)
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Aside: why the heck do applications think that their data is so important
> that they need to fsync it all the time.  I used to run a kernel on my
> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> pleasurable.

So, if having fake fsync() and fdatasync() is pleasurable for laptop
and desktop, may be it's time to add option into Kconfig which
disables normal fsync behaviour in favor of robust desktop?
