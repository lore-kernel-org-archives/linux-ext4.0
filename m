From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: tune2fs -O ^metadata_csum not checking bitmap failures
Date: Wed, 10 Sep 2014 17:10:21 -0400
Message-ID: <BAY179-W439AA99AF43810A0FC1C49FDCF0@phx.gbl>
References: <BAY179-W1203B52FCFC4FE2CA267BDFDCF0@phx.gbl>,<20140910204840.GH10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc4s25.hotmail.com ([65.54.190.227]:53676 "EHLO
	BAY004-OMC4S25.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbaIJVKW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 17:10:22 -0400
In-Reply-To: <20140910204840.GH10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Date: Wed, 10 Sep 2014 13:48:40 -0700
> From: darrick.wong@oracle.com
> To: thomas_reardon@hotmail.com
> CC: linux-ext4@vger.kernel.org
> Subject: Re: tune2fs -O ^metadata_csum not checking bitmap failures
>
> On Wed, Sep 10, 2014 at 04:30:41PM -0400, TR Reardon wrote:
>> When running tune2fs -O ^metadata_csum, disable_uninit_bg() is calle=
d to
>> reset the gdt. However, return value is not checked, which allows a =
failure
>> (say, a block bitmap failure somewhere, among other errors) to conti=
nue
>> through to rewrite_metadata_checksums()
>>
>> This seems wrong; should not the rewrite occur only if
>> disable/enable_uninit_bg() succeeds?
>
> The rewrite will fail if either of the error cases in disable_uninit_=
bg() fail,
> since rewrite_metadata_checksums() also tries to load the bitmap and =
scan the
> inodes.

Actually, rewrite_metadata_checksums() loads the bitmap with checksums =
OFF, which in the test I just ran, will succeed. =A0This leaves the fs =
in a weird half-checksummed state.

I should have been clearer above: if the initial disable_uninit_bg() fa=
ilure occurs because of a *checksum error*, then we get into this confu=
sed state. =A0Given that people would possibly try to disable metadata_=
csum if there are checksum errors, this seems like a fairly common scen=
ario.


 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
