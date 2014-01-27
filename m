From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How many files to create in one directory?
Date: Mon, 27 Jan 2014 13:48:29 -0600
Message-ID: <52E6B80D.7060807@redhat.com>
References: <52E607B1.2060206@jprs.co.jp> <52E69F3F.2000104@redhat.com> <20140127193950.GA20411@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Masato Minda <minmin@jprs.co.jp>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbaA0Tsf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jan 2014 14:48:35 -0500
In-Reply-To: <20140127193950.GA20411@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/27/14, 1:39 PM, Theodore Ts'o wrote:
>> It will depend on the length of the filenames.  But by my calculations,
>> for average 28-char filenames, it's closer to 30 million.
> 
> Note that there will be some very significant performance problems
> well before a directory gets that big.  For example, just simply doing
> a readdir + stat on all of the files in that directory (or a readdir +
> unlink, etc.) will very likely result in extremely unacceptable
> performance.

Yep, that's the max possible, not the max useable.  ;)

(Although, I'm not sure in practice what max useable looks like, TBH).

-Eric

> So if you can find some other way of avoiding allowing the file system
> that big (i.e., using a real database instead of trying to use a file
> system as a database, etc.), I'd strongly suggest that you consider
> those alternatives.
> 
> Regards,
> 
> 					- Ted
> 

