From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs: use ALL_CFLAGS to build gen_crc32ctable
Date: Mon, 10 Oct 2011 13:42:39 -0500
Message-ID: <4E933C9F.10102@redhat.com>
References: <4E89DF57.90806@redhat.com> <20111004030232.GA28372@thunk.org> <4E932DBE.7080203@redhat.com> <4E9330FA.4070307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1JJSmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 14:42:43 -0400
In-Reply-To: <4E9330FA.4070307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/11 12:52 PM, Eric Sandeen wrote:

> mv: cannot stat `t-es.gmo': No such file or directory
> mv: cannot stat `t-ca.gmo': No such file or directorymake[2]: *** [es.gmo] Error 1
> 
> -Eric

Ok, I needed gettext in the build root now.

It should probably fail more gracefully, but I won't worry about that for now.

I also noticed that configure didn't really handle the missing msgfmt:

checking for msgfmt... no
checking for gmsgfmt... :

I'll take a quick look at that.

Anyway, latest WIP release is finally in Rawhide.  :)

-Eric
