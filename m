From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compilebench numbers for ext4
Date: Mon, 22 Oct 2007 19:48:54 -0400
Message-ID: <20071022194854.0c98d583@think.oraclecorp.com>
References: <20071022193104.0beafeca@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:37867 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXJVXuy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2007 19:50:54 -0400
Received: from agmgw1.us.oracle.com (agmgw1.us.oracle.com [152.68.180.212])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id l9MNopes027950
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 17:50:52 -0600
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by agmgw1.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id l9LMeFJc016337
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 17:50:51 -0600
In-Reply-To: <20071022193104.0beafeca@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 22 Oct 2007 19:31:04 -0400
Chris Mason <chris.mason@oracle.com> wrote:
 
> I did expect delayed allocation to help the write phases of
> compilebench, especially the parts where it writes out .o files in
> random order (basically writing medium sized files all over the
> directory tree).  But, every phase except reads showed huge
> improvements.
> 
> http://oss.oracle.com/~mason/compilebench/ext4/ext-create-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-compile-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-rm-compare.png

This might make the IO during reads a little easier to see.  The dirs
will look like the kernel after a make -j.  So each directory will have
a bunch of small .c files that are close together and a bunch of .o
files that are randomly created across the tree.

http://oss.oracle.com/~mason/compilebench/ext4/ext4-read.mpg

-chris
