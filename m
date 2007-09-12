From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fw: ext3 dir_index causes an error
Date: Wed, 12 Sep 2007 14:40:16 -0500
Message-ID: <46E840A0.4030504@redhat.com>
References: <20070531211546.86fc9db8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, hooanon05@yahoo.co.jp,
	sct@redhat.com, adilger@clusterfs.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbXILTk1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2007 15:40:27 -0400
In-Reply-To: <20070531211546.86fc9db8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> Ted is dir_index maintainer ;)
> 
> That's a nice-looking bug report, btw.  Thanks.
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 01 Jun 2007 13:01:07 +0900
> From: hooanon05@yahoo.co.jp
> To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
> Subject: ext3 dir_index causes an error
> 
> 
> 
> Hello,
> 
> First of all, I really appricate your great works.
> Now I've found a problem around dir_index feature.
> Here is a report following linux/REPORTING-BUGS.
> 
> 
> [1.] One line summary of the problem:
> ext3 dir_index causes an error

I'm looking at this now, FWIW... pretty easy to reproduce on ppc64,
though I've not yet hit it on x86.

-Eric
