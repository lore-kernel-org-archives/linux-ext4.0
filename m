From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: fold two if statements into one
Date: Sat, 29 Oct 2011 09:14:45 -0400
Message-ID: <20111029131445.GE19536@thunk.org>
References: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40638 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761Ab1J2SMk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:40 -0400
Content-Disposition: inline
In-Reply-To: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 26, 2011 at 03:11:49PM +0800, Yongqiang Yang wrote:
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)

Unfortunately this patch is incorrect since it changes when the else
clause would get executed:

       if (a) {
       	   if (b) {
	       ...
	   }
       } else {
           ...
       }

is not the same as:

       if (a && b) {
	   ...
       } else {
           ...
       }

Regards,

					- Ted
