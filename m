From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: Strange (varying) limit on number files in directory ?
Date: Fri, 13 May 2011 08:29:32 -0600
Message-ID: <7A464EA2-9841-4C3D-B7D1-3D0711951F5E@whamcloud.com>
References: <201105131336.00979.mateusz-lists@ant.gliwice.pl>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49628 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1EMO3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 10:29:32 -0400
Received: by iwn34 with SMTP id 34so2310200iwn.19
        for <linux-ext4@vger.kernel.org>; Fri, 13 May 2011 07:29:31 -0700 (PDT)
In-Reply-To: <201105131336.00979.mateusz-lists@ant.gliwice.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-13, at 5:36 AM, Mateusz Korniak <mateusz-lists@ant.gliwice.pl> wrote:
> I am hitting strange number of files inside directory limitation.
> I am able to create only around 120k files.
> Number varies [1] as seems I am able to add files with some filenames but with 
> other creation fails [2].
> 
> Files have structure <small_ind><sha/md5sum> [3].
> All on linux box [4],[5], having plenty of frees space [6].
> Filesystem fscked  - everything ok.
> 
> 
> [3]:
> 494_0cf1500e1ecbeecb3282b1e68b2df53b77d06665  
> 494_40654eec2dd15e4065e49faa2ea226dd25191457  
> 
> [5]:
> tune2fs -l /dev/md7
> tune2fs 1.41.11 (14-Mar-2010)
> 
> Block count:              117190656
> 
> Block size:               1024

Limit is because you must have formatted the filesystem with 1023-byte blocksize. There is a 2-level limit on htree directories, and with the long filenames you are using you only get about 16 entries in each leaf block. With 1024-byte blocks there can be at most (1024-16)/8*(1024-8)/8*3/4= 192k entries with perfect hashing.

In order to exceed this limit you unfortunately need to format your fs with a larger blocksize (or fix htree to allow more than depth 2).

Andreas
