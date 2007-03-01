From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 23:11:18 +0000
Message-ID: <20070301231118.427544a4@lxorguk.ukuu.org.uk>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<45E74238.3040606@goop.org>
	<20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
	<45E74E30.8080909@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45E74E30.8080909@goop.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 01 Mar 2007 14:05:36 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Alan wrote:
> > A lot of people get confused about -ENOTTY, but it is the return for
> > attempting to use an ioctl on the wrong type of object, so this appears
> > to be quite correct.
> 
> This is a syscall though; ENOSYS is probably a better match.

ENOSYS indicates quite different things and ENOTTY is also used for
syscalls. I still think ENOTTY is correct.
