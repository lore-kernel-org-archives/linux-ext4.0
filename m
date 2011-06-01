From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: password protect or encrypt part of the file system like file
 or directory
Date: Wed, 01 Jun 2011 00:35:19 -0500
Message-ID: <4DE5CF97.6080406@redhat.com>
References: <BANLkTi=-5qpYSTmY2y2W2NyP2fg_aw_a7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: unni krishnan <list@mutexes.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1FAFfV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jun 2011 01:35:21 -0400
In-Reply-To: <BANLkTi=-5qpYSTmY2y2W2NyP2fg_aw_a7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/1/11 12:27 AM, unni krishnan wrote:
> Hi,
> 
> I just want to know, if it is possible to protect a file or directory
> at file system level, so that nobody can access it without knowing the
> authentication credentials irrespective of the system it is mounted.

You can use ecryptfs to do this sort of thing.

-Eric

> --
> Thank you,
> Unni
> http://www.mutexes.org/
> http://www.mutexes.org/imdb-movie-fetcher/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

