From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 19:57:17 -0500
Message-ID: <5243866D.1000909@redhat.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com> <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com> <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com> <524302D5.10701@redhat.com> <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com> <52431462.1090906@redhat.com> <CAOWv6b3_DbKjD5aGa1g-zEbVyJOar7NXLbaVA8ZKx+9s62bO2A@mail.gmail.com> <5243597F.1010108@redhat.com> <CAOWv6b2X9cwd7brTc2YaO7Fo9M_RqegCkn4uYcSv=5M8Z7_U2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: InvTraySts <invtrasys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab3IZA5U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Sep 2013 20:57:20 -0400
In-Reply-To: <CAOWv6b2X9cwd7brTc2YaO7Fo9M_RqegCkn4uYcSv=5M8Z7_U2Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/25/13 6:57 PM, InvTraySts wrote:
> Blkid for the drives say:
> 
> root@server:~# blkid /dev/sdf
> root@server:~#
> root@server:~# blkid /dev/sdf1
> root@server:~#
> 

Jan got it right, I wasn't thinking about dd'ing the entire drive w/ partition table.

Onward! ;)

-Eric

