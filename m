From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: fix src/seek_sanity_test -t option
Date: Tue, 28 May 2013 10:57:22 -0500
Message-ID: <51A4D3E2.3020204@sgi.com>
References: <519EF4AE.60702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:33253 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934641Ab3E1P4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 11:56:30 -0400
In-Reply-To: <519EF4AE.60702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/24/2013 12:03 AM, Eric Sandeen wrote:
> _require_seek_data_hole() does not work because
> the -t (test) option of seek_sanity_test is broken,
> because of an early check for (argc != 2):
>
> # src/seek_sanity_test -t foo
> Usage: src/seek_sanity_test base_file_path
>
> So _require_seek_data_hole() doesn't see the
> "Kernel does not support" string it's looking for,
> and passes the check.
>
> So rather than _notrun-ing the test, it proceeds to
> fail with noisy errors.
>
> Fix that, make a common usage() function, and check for
> too many args as well.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, this has been committed:

commit bd13bf9e2a87a40d3aab2644967029b854ed2d11
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue May 28 10:37:39 2013 -0500

     xfstests: fix src/seek_sanity_test -t option

--Rich
