From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest-bld generic/018 fails due to e4defrag issue
Date: Thu, 10 Apr 2014 23:07:39 -0400
Message-ID: <20140411030739.GD23620@thunk.org>
References: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
 <20140409220320.GC15303@thunk.org>
 <CAGW2f1Fn2caBtQPjZnXyMdVf9H6wGvS_0YrLReggwujKZXL8CQ@mail.gmail.com>
 <20140410135637.GC15925@thunk.org>
 <20140410184215.GA9171@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jon ernst <jonernst07@gmail.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52740 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaDKDHm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 23:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20140410184215.GA9171@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 11:42:15AM -0700, Darrick J. Wong wrote:
> 
> From a quick visual inspection and a sparse bitwise check, e4defrag looks 64bit
> clean.

Thanks for checking!  I've applied Jon's patch.

       	   	      	   	   	 - Ted
