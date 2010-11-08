From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH -v4] ext4: handle writeback of inodes which are being
 freed
Date: Mon, 8 Nov 2010 11:28:32 -0500
Message-ID: <20101108162832.GA22401@elliptictech.com>
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
 <20101103182229.GA8766@elliptictech.com>
 <20101103205306.GA3627@elliptictech.com>
 <20101107212143.GA28396@thunk.org>
 <20101108011919.GN13830@dastard>
 <20101108050052.GA3099@thunk.org>
 <20101108060535.GB3099@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:37812 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753869Ab0KHQ2j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Nov 2010 11:28:39 -0500
Content-Disposition: inline
In-Reply-To: <20101108060535.GB3099@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-08 01:05 -0500, Ted Ts'o wrote:
> Subject: [PATCH -v4] ext4: handle writeback of inodes which are being freed

After several successful 'make install' tests with this patch:

Tested-by: Nick Bowler <nbowler@elliptictech.com>

Thanks.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
