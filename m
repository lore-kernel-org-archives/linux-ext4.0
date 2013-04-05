From: Anand Avati <avati@redhat.com>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Fri, 05 Apr 2013 16:26:34 -0700
Message-ID: <515F5DAA.8000105@redhat.com>
References: <5154AAB4.2000701@redhat.com> <5159A8D5.1000204@redhat.com> <20130401181718.GB22443@thunk.org> <5159D03F.5000606@redhat.com> <20130401190804.GD22443@thunk.org> <5159E4AC.7050307@redhat.com> <20130401200052.GA24097@thunk.org> <5159E88F.8030704@redhat.com> <307C00EE-45DE-48A4-9FB7-3F164B51A524@redhat.com> <1365203125.15177.33.camel@jesse> <20130405232821.GA15810@pad.fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Bartlett <abartlet@samba.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, gluster-devel@nongnu.org,
	jra@samba.org
To: "J. Bruce Fields" <bfields@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab3DEXfw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 19:35:52 -0400
In-Reply-To: <20130405232821.GA15810@pad.fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/05/2013 04:28 PM, J. Bruce Fields wrote:

> knfsd is still returning 32-bit cookies to v2 clients (that's the
> protocol), but I doubt v2 support is very critical for Ganesha.

The last I heard, Ganesha has officially removed all NFSv2 code from 
their repo and do not support it at all anymore.

Avati

