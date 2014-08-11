From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: New feature/project ideas
Date: Mon, 11 Aug 2014 20:12:44 +0200
Message-ID: <6C7C8265-F142-4C07-8EDC-B0DBFAB8CBF5@dilger.ca>
References: <1407700151.84765.YahooMailNeo@web192906.mail.sg3.yahoo.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vimal A R <arvimal@yahoo.in>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45404 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHKSMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 14:12:49 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so8959017wgh.14
        for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 11:12:48 -0700 (PDT)
In-Reply-To: <1407700151.84765.YahooMailNeo@web192906.mail.sg3.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Many of the projects listed on that page are already implemented. 

I think one of the more important ones that has not yet been done
is the per-block journal checksums and improved recovery in case
of checksum failure on a transaction. 

Cheers, Andreas

> On Aug 10, 2014, at 21:49, Vimal A R <arvimal@yahoo.in> wrote:
> 
> Hello,
> 
> I came across https://ext4.wiki.kernel.org/index.php/TODO_list while searching for an idea as part of my undergraduate CS project. 
> 
> 
> I would like to know if this list is updated/latest, and if not, are there any project ideas which would be apt for a 3-4 month time-frame. Any ideas and suggestions are welcome.
> 
> Thank you,
> 
> Vimal
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
