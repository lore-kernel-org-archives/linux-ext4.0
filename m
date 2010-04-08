From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Thu, 08 Apr 2010 10:32:04 -0500
Message-ID: <4BBDF6F4.2020208@redhat.com>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com> <4BBD3365.90306@gmail.com> <4BBD5740.4070101@redhat.com> <4BBD5D90.4090203@redhat.com> <4BBD5FDB.9010100@redhat.com> <4BBDC2A3.1040901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab0DHPcJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 11:32:09 -0400
In-Reply-To: <4BBDC2A3.1040901@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nebojsa Trpkovic wrote:

> Well, to be honest, I'm not some programmer guy, so I doubt my skills
> can be of any help here.
> 
> Second, unfortunately, my SSD is now my root partition (just one big
> sda1), so I cannot experiment with it too much.

Well, you might just keep in mind that:

1) trimming these small amounts has actually looked very inefficient, and
2) data=writeback really isn't very safe in the face of a crash or power loss, and
3) hopefully we'll have a better trim solution eventually.

-Eric

