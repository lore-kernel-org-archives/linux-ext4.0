From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Fix compilation with -DDX_DEBUG v2
Date: Sat, 16 Jul 2011 19:41:06 -0400
Message-ID: <20110716234106.GB2717@thunk.org>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain>
 <20110620202849.2473133.84386.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@whamcloud.com, colyli@gmail.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58161 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1GPXlN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jul 2011 19:41:13 -0400
Content-Disposition: inline
In-Reply-To: <20110620202849.2473133.84386.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 10:28:49PM +0200, Bernd Schubert wrote:
> changes from v1 -> v2:
> Use %p as suggested by Coly Li

The problem with %p:

    1)  It prints numbers that will never be larger than 4096 with as 
        "00000012"
    2)  It prints the number 0 as "  (null)".

These two things mean that we get messages like this:

names: foo:7141e93c.  (null) bar:745c4a06.00000012 baz:79817344.00000024 quux:7e85a800.00000036 ...

instead of:

names: foo:7141e93c.0 bar:745c4a06.12 baz:79817344.24 quux:7e85a800.36 ...

(did anyone even try this and check to see what would happen with %p?)

I've applied this patch, with a change so that we print the number
with %u and with an explicit cast to unsigned.

						- Ted
