From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors: Checksum for group .. failed
Date: Tue, 13 Nov 2012 14:09:27 -0700
Message-ID: <7CDB2F8F-6316-424C-8F37-5E5CEEF8F29D@dilger.ca>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com> <20121109000156.GQ19977@thunk.org> <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com> <20121112161646.GF4895@thunk.org> <CACDumsT=cjmNFtAWKMXvkvujHgixEX44xEif+qo3Q04f1N=QsQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "kaefert@gmail.com" <kaefert@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27659 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab2KMVJa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 16:09:30 -0500
In-Reply-To: <CACDumsT=cjmNFtAWKMXvkvujHgixEX44xEif+qo3Q04f1N=QsQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-12, at 9:29 AM, kaefert@gmail.com wrote:
> 2012/11/12 Theodore Ts'o <tytso@mit.edu>:
>> Also, can you disable the German translation to make
>> it easier for me to investigate?
> 
> Could you tell me how to disable the German translations? sorry...

# LANG=C e2fsck -f ...

Cheers, Andreas





