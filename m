From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 12:14:25 -0400
Message-ID: <20120319161425.GB2502@thunk.org>
References: <20120319040950.GG31682@thunk.org>
 <20120319.001430.1735750114727679638.davem@davemloft.net>
 <20120319043420.GL31682@thunk.org>
 <20120319.011211.89954160788757412.davem@davemloft.net>
 <20120319153133.GA2502@thunk.org>
 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, joe@perches.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Anca Emanuel <anca.emanuel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47041 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161624Ab2CSQO1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 12:14:27 -0400
Content-Disposition: inline
In-Reply-To: <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 05:51:17PM +0200, Anca Emanuel wrote:
> Ted Ts'o: this effort is like BKL remove, ok, not like that.
> In 5 years, to have an standard. Mmm, maybe, less.
>
> Joe, prease remind to all one more time your goal, and the benefits.

Getting rid of the BKL had real, user-visible benefits.  Invoking a
war on printk has no real-world benefits.

It's about the same utility as fixing "colour" to be "color" because
people think standardized spelling is somehow critically important.
Guess what?  The world will keep spinning and users will not notice
the difference if we use printk vs. pr_info

    	       	     	 	    - Ted
