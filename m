From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 01/10] xfstests: add fio requirement V2
Date: Fri, 1 Mar 2013 09:43:10 -0600
Message-ID: <5130CC8E.6090406@sgi.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org> <1361356935-29153-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <dchinner@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:45327 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3CAPnK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 10:43:10 -0500
In-Reply-To: <1361356935-29153-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> FIO is very flexible io generator, I would call it IO swiss knife.
> Currently we have tonns of hardcoded application which reproduces
> some predefined scenario. This approach has obvious dissadvantages
> 1) Lack of flexability: one written it is hard to modify it in future
> 2) Code base is large, many routines written again and again
>
> At the same time add new fio based tast is just add simle INI file.
> This greatly simplify code review. I do beleve that some day we will
> replace most of hardcoded io binaries with fio.
>
> One who is planning to run $FIO_PROG should first check that system
> contains appropriate version which is able to handle jobfile
> for example:  _require_fio 286-job.fio
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Minor typos in the description, but looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


