From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4 newbie trying to recover its partition table
Date: Sun, 27 Nov 2011 14:29:39 -0500
Message-ID: <20111127192939.GL5167@thunk.org>
References: <CAEZOgh80gEP=oW=9adxN7HQHVFjHYJHaT=RKRxDyfUXOTfCGJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lucas Teixeira <lucas@lucasteixeira.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59871 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1K0TaI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Nov 2011 14:30:08 -0500
Content-Disposition: inline
In-Reply-To: <CAEZOgh80gEP=oW=9adxN7HQHVFjHYJHaT=RKRxDyfUXOTfCGJQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 27, 2011 at 02:06:44PM -0200, Lucas Teixeira wrote:
> Hello,
> 
> For more than a year I've been trying to recover data from a harddisk
> of mine. I have really important personal files there, and I would
> like to recover it myself, as I don't know of any recovering service
> that I would trust to analyze ext4 partitions.
> 
> I don't know if anyone here even has the time to read my diagnosis
> (pasted below).
> 
> **I would like good resources and tips to learn ext4 structure and
> dive into e2fsprogs source code, in order to recover the files in my
> misteriously lost partitions.**

Have you tried using the program "gpart"?  It's the go-to program for
recovering damaged partition tables in my book.

						- Ted
