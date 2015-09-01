From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Tue, 1 Sep 2015 11:17:48 -0400
Message-ID: <55E5C19C.7030809@suse.com>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <55E4D5DE.2030709@gmail.com>
 <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
 <55E59F91.6020309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Raymond Jennings <shentino@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E59F91.6020309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/1/15 8:52 AM, Eric Sandeen wrote:
> On 8/31/15 5:39 PM, Linus Torvalds wrote:
>> On Mon, Aug 31, 2015 at 3:31 PM, Raymond Jennings
>> <shentino@gmail.com> wrote:
>>> 
>>> That said, I wouldn't mind myself if the ext4 driver were given
>>> a very grueling regression test to make sure it can actually
>>> handle old ext3 systems as well as the ext3 driver can.
>> 
>> That's not my only worry. Things like "can you go back to
>> ext3-only" is an issue too - I don't think that's been a big
>> priority for ext4 any more, and if there are any existing
>> hold-outs that still use ext3, they may want to be able to go
>> back to old kernels.
> 
> Others have said it as well, but I'll restate: Yes, you can go
> "back."
> 
> But there's no real "going back" needed, because mounting an ext3 
> filesystem with ext4.ko hasn't "gone anywhere."  If you use
> ext4.ko, you are running with a newer driver, but not a newer disk
> format.
> 
>> So it's not just a "you can use ext4 instead" issue. Can you do
>> that *without* then forcing an upgrade forever on that partition?
>> I'm not sure the ext4 people are really even willing to guarantee
>> that kind of backwards compatibility.
> 
> Yeah, we are, I think I remember making an explicit stink about
> that quite a while ago.  But I'm satisfied; we do use
> CONFIG_EXT4_USE_FOR_EXT23 in RHEL7, and we wouldn't do that if it
> might change disk format behind our users' backs.

As a "me too" datapoint, we do the same thing with SLE12.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJV5cGbAAoJEB57S2MheeWy9z8QALz0EPV2V9MPzSTkQ/DyvcEK
V8GxQyHpOSwVLqU/J8f9+1vM7dbRR9bjXuN8YAZ/bmTf5GQA4opuCZK4KanK3xeo
JSQeFfO9O4gb3aiKdVxxXS3RhejR4WhQ+nQQ3HOIIXCjauU4vd88UH1tjcBR8PdE
DXKtq1KpqIWc5zLr22AgTRwkDiYauaziK2i6922DVl0rSOjfFw4BoV91pgE0pLgi
ojXKosmpST1VOlHKw7l2yOeMdVYUn1wJFgOprCXSLNwckszcqLgNbRYaOaiZmh7Z
c4zWdOkKQDI1/+THtNniF7xiDx2vFgtCSKbaU+hdsshxBHntLIIRj7vqOqfVLb85
m8lyshQDen8y7bahimCfr/hIGyXBuotl+jS4sryABInBf3AkuR3kI9gYJrb6YDWU
jt/0XnT4OIboB1G/Op+SLeNBBR+1RQn9iu559dw2JFQJFeT9JJOvbyaYU5Ijl8I4
eBxebee9laat3atbKVe4HTzGgNzbwCoA8KZuhtaDncR+jd6tsiSLsdlVKZw/P3g9
J35QNlOt6FyecDa9G3OYcpLsxffdv/fke2yT+R6LiN54oVY77OYRjFNY2X27yHWX
76qAOj+tkntfvFV5BjElT+uqXxqebb/kwLt2gUJJ68U/lVVYFHDJKjE2XXdf5omy
/N/PcMenBbsGq6H0UvzS
=G4VO
-----END PGP SIGNATURE-----
