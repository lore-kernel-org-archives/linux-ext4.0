From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/3] generic/022: update expected output after the test
 was renamed
Date: Sat, 12 Apr 2014 23:07:14 -0500
Message-ID: <534A0D72.10304@sandeen.net>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu> <1397343317-14669-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35373 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaDMEHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 00:07:14 -0400
In-Reply-To: <1397343317-14669-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/12/14, 5:55 PM, Theodore Ts'o wrote:
> After generic/022 was renamed by commit 21723cdb, the wrong test
> number was put into generic/022.out.  Fix this.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Lukas Czerner <lczerner@redhat.com>

Lukas sent this a couple days ago as well.

In any case, again, Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/022.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/022.out b/tests/generic/022.out
> index 96c2d33..fbffa59 100644
> --- a/tests/generic/022.out
> +++ b/tests/generic/022.out
> @@ -1,4 +1,4 @@
> -QA output created by 009
> +QA output created by 022
>  	1. into a hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
> 

