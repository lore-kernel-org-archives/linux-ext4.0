From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Wed, 23 Apr 2008 19:58:50 +0300
Message-ID: <84144f020804230958h66d7f244gd90f832d403758e@mail.gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	 <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
	 <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
	 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
	 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
	 <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
	 <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
	"Ingo Molnar" <mingo@elte.hu>, "Jiri Slaby" <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	"David Miller" <davem@davemloft.net>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	"Christoph Lameter" <clameter@sgi.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:16856 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYDWQ6w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 12:58:52 -0400
Received: by el-out-1112.google.com with SMTP id n30so989444elf.21
        for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 09:58:51 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T24gV2VkLCBBcHIgMjMsIDIwMDggYXQgNjo1MyBQTSwgTGludXMgVG9ydmFsZHMKPHRvcnZhbGRz
QGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToKPiAgICBQYWRkaW5nIDB4ZmZmZjgxMDAyMDFh
MDAwMDogIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIDZiIGtr
a2tra2tra2tra2tra2sKPiAgICAuLi4uCj4gICAgUGFkZGluZyAweGZmZmY4MTAwMjAxYTcxYTA6
ICA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiA2YiBhNSBra2tra2tr
a2tra2tra2vSkAo+ICAgIFBhZGRpbmcgMHhmZmZmODEwMDIwMWE3MWIwOiAgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgMDAgMDAgMWEgMjAgMDAgODEgZmYgZmYg0JzQnNCc0JzQnNCc0JzQnC4uLi4u
LtGP0Y8KPiAgICBQYWRkaW5nIDB4ZmZmZjgxMDAyMDFhNzFjMDogIGNkIDcwIDE3IGEwIGZmIGZm
IGZmIGZmIDAwIDAwIDAwIDAwIDczIDA1IDAwIDAwINCdcC4u0Y/Rj9GP0Y8uLi4ucy4uLgo+ICAg
IFBhZGRpbmcgMHhmZmZmODEwMDIwMWE3MWQwOiAgYjYgNTQgNTggMDAgMDEgMDAgMDAgMDAgZDUg
NzEgMjYgODEgZmYgZmYgZmYgZmYgwrZUWC4uLi4u0KVxJi7Rj9GP0Y/Rjwo+Cj4gICAgUGFkZGlu
ZyAweGZmZmY4MTAwMjAxYTcxZTA6ICAwMCAwMCAwMCAwMCA3YyAwNSAwMCAwMCA5NyA1NCA1OCAw
MCAwMSAwMCAwMCAwMCAuLi4ufC4uLi5UWC4uLi4uCj4KPiAgICB3aGljaCBpbiB0dXJuIGlzIGlu
dGVyZXN0aW5nIGJlY2F1c2UgaXQgdmVyeSBtdWNoIGxvb2tzIGxpa2UgU0xVQgo+ICAgIHJlLXVz
ZWQgYSBwYWdlIGZvciBzb21ldGhpbmcgZWxzZSAodGhlIHZhbHVlcyB0aGF0IHRoaW5ncyBnb3QK
PiAgICBvdmVyd3JpdHRlbiBieSBhcmUgbGFyZ2VseSBTTFVCJ3Mgb3duIHBvaXNvbiBieXRlczog
NmIgaXMgUE9JU09OX0ZSRUUsCj4gICAgdGhlIGE1IGF0IHRoZSBlbmQgb2YgdGhlIGxpc3Qgb2Yg
NmIncyBpcyBQT0lTT05fRU5ELCB3aGlsZSBjYyBpcwo+ICAgIFNMVUJfUkVEX0FDVElWRSkuCj4K
PiAgVG8gbWUsIHRoYXQgcGF0dGVybiBsb29rcyBsaWtlIGFuIG9yZGVyLTMgYWxsb2NhdGlvbiAo
Y29ycmVjdDogdGhhdCdzIHdoYXQKPiAga21hbGxvYy00MDk2IGlzIHN1cHBvc2VkIHRvIGJlIHVz
aW5nISkgZ290IHJlbGVhc2VkLCBhbmQgdGhlIHN0dWZmIGF0IHRoZQo+ICBlbmQgKHdpdGggc2x1
YiBkZWJ1Z2dpbmcsIHRoZXJlJ3Mgb25seSByb29tIGZvciA3IDQwOTYtYnl0ZSBhbGxvY2F0aW9u
cwo+ICB0aGVyZSwgc28gNzFiMCBpcyBwYXN0IHRoZSBlbmQpIGluIHRoYXQgU0xVQiBkZWJ1ZyBp
bmZvLgo+Cj4gIFRoZSBmaXJzdCB3b3JkIG9mIHRoYXQgYnVzeSBhbGxvY2F0aW9uIGlzIGZmZmY4
MTAwMjAxYTAwMDAsIHdoaWNoIGlzIGFsc28KPiAgdGhlIGJhc2UgcG9pbnRlciB0byB0aGUgd2hv
bGUgb3JkZXItMyBwYWdlICgiRnJlZSBwb2ludGVyIiksIGZvbGxvd2VkIGJ5Cj4gIHRoZSBTTEFC
IHRyYWNraW5nIGRhdGEuCgpJcyB0aGUgUE9JU09OX0ZSRUUgKCI2YiIpIHJlZ2lvbiByZWFsbHkg
Y29udGlndW91cyBaZGVuZWs/IFRoZSBwcm9ibGVtCmhlcmUgaXMgdGhhdCB0aGUgb2JqZWN0IGxv
b2tzIHRvIGJlIDI5MTA0IGJ5dGVzIHRoYXQgaXMgc3ViamVjdCB0bwprbWFsbG9jX2xhcmdlKCkg
d2hpY2ggYnktcGFzc2VzIFNMVUIgcG9pc29uaW5nIGNvbXBsZXRlbHkuCgogICAgICAgICAgICAg
ICAgICAgICAgICBQZWtrYQo=
