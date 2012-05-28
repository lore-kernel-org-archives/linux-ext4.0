From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: libquota: add a quotactl prototype
Date: Mon, 28 May 2012 09:31:42 -0600
Message-ID: <9479769F-26BE-415D-804A-4766736ACEF5@whamcloud.com>
References: <1337715689-7116-1-git-send-email-vapier@gentoo.org> <20120528142032.GA1578@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Mike Frysinger <vapier@gentoo.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57398 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2E1Pbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 May 2012 11:31:34 -0400
Received: by dady13 with SMTP id y13so4269967dad.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 May 2012 08:31:34 -0700 (PDT)
In-Reply-To: <20120528142032.GA1578@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-28, at 8:20, Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, May 22, 2012 at 09:41:29AM -0000, Mike Frysinger wrote:
>> The commit 0df8a27bbaf51b55c0e8c3a533ef4c2ff9d79c9f removed the system
>> quota.h include, but in doing so, added the problem:
>> mkquota.c:55:2: warning: implicit declaration of function 'quotactl'
>> 
>> Since we're maintaining a copy of quota.h, add a proper func prototype.
>> 
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Thanks, applied.

This patch caused a compile failure on my FC 13 system, when I had no problem before, because caddr_t was not defined...

Cheers, Andreas