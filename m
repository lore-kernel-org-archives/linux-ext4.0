From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Wed, 1 Dec 2010 15:52:53 -0700
Message-ID: <3D193EF5-5995-4674-881B-DF74B855CE32@dilger.ca>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:18425 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0LAWwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 17:52:55 -0500
In-Reply-To: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-12-01, at 10:41, Lukas Czerner wrote:
> I am presenting you an initial parch, which works for me quite nicely, however so far it did received just limited testing. Nevertheless you
> can try it simply by invoking e2image with '-q' parameter like this:
> 
> 	e2image -q /dev/sda1 myimage

Probably "-q" isn't the best name, since that normally means "quiet".  Maybe "-Q"?

Cheers, Andreas





