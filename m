From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: possible different donor file naming in e4defrag
Date: Fri, 15 Aug 2014 16:45:06 -0400
Message-ID: <BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>,<20140815203909.GM2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc4s26.hotmail.com ([65.54.190.231]:57842 "EHLO
	BAY004-OMC4S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaHOUuM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Aug 2014 16:50:12 -0400
In-Reply-To: <20140815203909.GM2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Fri, Aug 15, 2014 at 04:12:40PM -0400, TR Reardon wrote:
>> Currently, e4defrag creates a donor file _in the same directory_ of
>> the file being defrag'ed.
>>=20
>> The problem with this is that the containing directory times are
>> changed because of the transient presence of the donor file. Any
>> thoughts as to moving the donor to a better location, mount-root, or
>> /lost+found? Or, ugh, a configurable location, if non-privileged
>> defrag is important?
>=20
> How about we just reset the directory time? (Or does utime() not work=
?)
>=20
> --D

Er, yes, that's simpler. =A0And a SIGINT handler just to keep things ti=
dy?

+Reardon

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
