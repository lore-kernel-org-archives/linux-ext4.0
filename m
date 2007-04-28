From: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Date: Sat, 28 Apr 2007 17:12:34 -0400
Message-ID: <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Mike Galbraith" <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Jens Axboe" <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:56608 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030476AbXD1VMl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Apr 2007 17:12:41 -0400
Received: by py-out-1112.google.com with SMTP id a29so1066056pyi
        for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2007 14:12:40 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/28/07, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
> I most wonder, why vim fsyncs its swapfile regularly (blocking typing
> during that) and doesn't fsync the resulting file on :w  :-/

Never seen this.  Why would fsync block typing unless vim was doing
disk IO for every keystroke?

Lee
