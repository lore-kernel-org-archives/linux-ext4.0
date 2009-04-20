From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck -y says "yes" to "Abort?"
Date: Mon, 20 Apr 2009 13:33:31 -0500
Message-ID: <49ECBFFB.2050004@redhat.com>
References: <49E9DF6A.1090000@redhat.com> <20090418161710.GF19186@mit.edu> <49ECBF08.6030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZDTSdf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 14:33:35 -0400
In-Reply-To: <49ECBF08.6030806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:

> The only down side is when you try to automate this (say in an 
> appliance) and you don't have a human reading the output. In this case, 
> you might just want to invert the logic but in general, it does seem 
> dangerous to invert the logic for a long standing option,
> 
> Ric
> 

Maybe make something like "-yy" automatically answer "n" to anything
that would stop the fsck, and answer "y" to anything that it proposes
fixing?

-Eric
